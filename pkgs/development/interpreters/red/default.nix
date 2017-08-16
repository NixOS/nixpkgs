{ stdenv, stdenv_32bit, pkgsi686Linux, fetchFromGitHub, fetchurl }:

stdenv.mkDerivation rec {
  name = "red-v${version}";
  version = "0.6.3";
  src = fetchFromGitHub {
    rev = "6a43c767fa2e85d668b83f749158a18e62c30f70";
    owner = "red";
    repo = "red";
    sha256 = "1zh6xc728bs7r4v5jz1jjrdk0xd838xsxmvy9gfg75a3zffm0slr";
  };

  rebol = fetchurl {
    url = "http://www.rebol.com/downloads/v278/rebol-core-278-4-2.tar.gz";
    sha256 = "1c1v0pyhf3d8z98qc93a5zmx0bbl0qq5lr8mbkdgygqsq2bv2xbz";
  };

  buildInputs = [ pkgsi686Linux.curl stdenv_32bit ];

  r2 = "./rebol/releases/rebol-core/rebol";

  configurePhase = ''
    # Download rebol
    mkdir rebol/
    tar -xzvf ${rebol} -C rebol/
    patchelf --set-interpreter \
        ${stdenv_32bit.cc.libc.out}/lib/32/ld-linux.so.2 \
        ${r2}
  '';

  buildPhase = ''
    # Do tests
    #${r2} -qw run-all.r

    # Build test
    ${r2} -qw red.r tests/hello.red

    # Compiling the Red console...
    ${r2} -qw red.r -r environment/console/console.red

    # Generating docs...
    cd docs
    ../${r2} -qw makedoc2.r red-system-specs.txt
    ../${r2} -qw makedoc2.r red-system-quick-test.txt
    cd ../
  '';

  installPhase = ''
    mkdir $out

    # Install
    install -d $out/opt/red
    find quick-test -type f -executable -print0 | xargs -0 rm
    cp -R * $out/opt/red/
    rm -rf $out/opt/red/rebol
    install -Dm755 console $out/bin/red
    install -Dm644 BSD-3-License.txt                          \
        $out/share/licenses/${name}/BSD-3-License.txt
    install -Dm644 BSL-License.txt                            \
        $out/share/licenses/${name}/BSL-License.txt
    install -Dm644 docs/red-system-quick-test.html            \
        $out/share/doc/${name}/red-system-quick-test.html
    install -Dm644 docs/red-system-specs.html                 \
        $out/share/doc/${name}/red-system-specs.html

    # PathElf
    patchelf --set-interpreter                            \
        ${stdenv_32bit.cc.libc.out}/lib/32/ld-linux.so.2  \
        $out/opt/red/console
    patchelf --set-rpath ${pkgsi686Linux.curl.out}/lib \
        $out/opt/red/console
    patchelf --set-interpreter                            \
        ${stdenv_32bit.cc.libc.out}/lib/32/ld-linux.so.2  \
        $out/bin/red
    patchelf --set-rpath ${pkgsi686Linux.curl.out}/lib \
        $out/bin/red

  '';

  meta = with stdenv.lib; {
    description = ''
      New programming language strongly inspired by Rebol, but with a
      broader field of usage thanks to its native-code compiler, from system
      programming to high-level scripting, while providing modern support for
      concurrency and multi-core CPUs
    '';
    maintainers = with maintainers; [ uralbash ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = licenses.bsd3;
    homepage = http://www.red-lang.org/;
  };
}
