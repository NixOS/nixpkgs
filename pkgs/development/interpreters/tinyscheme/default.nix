{ lib
, stdenv
, fetchurl
, dos2unix
, runCommand
, tinyscheme
}:

stdenv.mkDerivation rec {
  pname = "tinyscheme";
  version = "1.42";

  src = fetchurl {
    url = "mirror://sourceforge/tinyscheme/${pname}-${version}.tar.gz";
    sha256 = "sha256-F7Cxv/0i89SdWDPiKhILM5A50s/aC0bW/FHdLwG0B60=";
  };

  nativeBuildInputs = [ dos2unix ];

  prePatch = "dos2unix makefile";
  patches = [
    # The alternate macOS main makes use of `ccommand` which seems to be
    # `MetroWerks CodeWarrier` specific:
    # https://ptgmedia.pearsoncmg.com/imprint_downloads/informit/downloads/9780201703535/macfix.html
    #
    # In any case, this is not needed to build on macOS.
    ./01-remove-macOS-main.patch

    # We want to have the makefile pick up $CC, etc. so that we don't have
    # to unnecessarily tie this package to the GCC stdenv.
    ./02-use-toolchain-env-vars.patch
  ] ++ lib.optionals stdenv.targetPlatform.isDarwin [
    # On macOS the library suffix is .dylib:
    ./03-macOS-SOsuf.patch
  ];
  postPatch = ''
    substituteInPlace scheme.c --replace "init.scm" "$out/lib/init.scm"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp init.scm $out/lib
    cp libtinyscheme* $out/lib
    cp scheme $out/bin/tinyscheme
  '';

  passthru.tests = {
    # Checks that the program can run and exit:
    simple = runCommand "${pname}-simple-test" {} ''
      ${tinyscheme}/bin/tinyscheme <<<"(quit 0)"
      echo "success" > $out
    '';
    fileIo = runCommand "${pname}-file-io-test" {} ''
      ${tinyscheme}/bin/tinyscheme <<EOF
        (call-with-output-file "$out"
          (lambda (p)
            (begin
                (write "success!" p)
                (newline p)
            )))
      EOF
    '';
    helpText = runCommand "${pname}-help-text-test" {} ''
      ${tinyscheme}/bin/tinyscheme '-?' | tee > $out || :
      [[ "$(cat $out)" =~ ^Usage: ]]
    '';
  };

  meta = with lib; {
    description = "Lightweight Scheme implementation";
    longDescription = ''
      TinyScheme is a lightweight Scheme interpreter that implements as large a
      subset of R5RS as was possible without getting very large and complicated.
    '';
    homepage = "https://tinyscheme.sourceforge.net/";
    changelog = "https://tinyscheme.sourceforge.net/CHANGES";
    license = licenses.bsdOriginal;
    mainProgram = pname;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
  };
}
