{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "graphene-hardened-malloc";
  version = "2";

  src = fetchurl {
    url = "https://github.com/GrapheneOS/hardened_malloc/archive/${version}.tar.gz";
    sha256 = "0zsl4vl65ic6lw5rzcjzvcxg8makg683abnwvy60zfap8hvijvjb";
  };

  installPhase = ''
    install -Dm444 -t $out/lib libhardened_malloc.so

    mkdir -p $out/bin
    substitute preload.sh $out/bin/preload-hardened-malloc --replace "\$dir" $out/lib
    chmod 0555 $out/bin/preload-hardened-malloc
  '';

  separateDebugInfo = true;

  doInstallCheck = true;
  installCheckPhase = ''
    pushd test
    make
    $out/bin/preload-hardened-malloc ./offset

    pushd simple-memory-corruption
    make

    # these tests don't actually appear to generate overflows currently
    rm read_after_free_small string_overflow eight_byte_overflow_large

    for t in `find . -regex ".*/[a-z_]+"` ; do
      echo "Running $t..."
      # the program being aborted (as it should be) would result in an exit code > 128
      (($out/bin/preload-hardened-malloc $t) && false) \
        || (test $? -gt 128 || (echo "$t was not aborted" && false))
    done
    popd

    popd
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/GrapheneOS/hardened_malloc";
    description = "Hardened allocator designed for modern systems";
    longDescription = ''
      This is a security-focused general purpose memory allocator providing the malloc API
      along with various extensions. It provides substantial hardening against heap
      corruption vulnerabilities yet aims to provide decent overall performance.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
