{ stdenv
, lib
, fetchFromGitHub
, fetchpatch2
, gnat
, gprbuild
, gnatcoll-core
, component
# component dependencies
, gmp
, libiconv
, xz
, readline
, zlib
, python3
, ncurses
, darwin
}:

let
  # omit python (2.7), no need to introduce a
  # dependency on an EOL package for no reason
  libsFor = {
    iconv = [ libiconv ];
    gmp = [ gmp ];
    lzma = [ xz ];
    readline = [ readline ];
    python3 = [ python3 ncurses ];
    syslog = [ ];
    zlib = [ zlib ];
  };
in


stdenv.mkDerivation rec {
  pname = "gnatcoll-${component}";
  version = "24.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "gnatcoll-bindings";
    rev = "v${version}";
    sha256 = "00aakpmr67r72l1h3jpkaw83p1a2mjjvfk635yy5c1nss3ji1qjm";
  };

  patches = [
    (fetchpatch2 {
      # Add minimal support for Python 3.11
      url = "https://github.com/AdaCore/gnatcoll-bindings/commit/cd650de5e3871d514447ec68b6de9fc11eadd062.patch?full_index=1";
      hash = "sha256-bJOTDMTsmXIAkzKpZyaM//+DGnqEA1W5e/RCIRtbf4Y=";
    })
    (fetchpatch2 {
      # distutils has been removed in Python 3.12
      url = "https://github.com/AdaCore/gnatcoll-bindings/commit/2c128911ecd0a7245a5691f6659f6533890c660b.patch?full_index=1";
      hash = "sha256-n0zk3ZD3pRQqaN+0kjuC51zEdtE5nVF8FDxPQuEqA+c=";
      excludes = [ ".gitlab-ci.yml" ];
    })
  ];

  nativeBuildInputs = [
    gprbuild
    gnat
    python3
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  # propagate since gprbuild needs to find referenced .gpr files
  # and all dependency C libraries when statically linking a
  # downstream executable.
  propagatedBuildInputs = [
    gnatcoll-core
  ] ++ libsFor."${component}" or [];

  # explicit flag for GPL acceptance because upstreams
  # allows a gcc runtime exception for all bindings
  # except for readline (since it is GPL w/o exceptions)
  buildFlags = lib.optionals (component == "readline") [
    "--accept-gpl"
  ];

  buildPhase = ''
    runHook preBuild
    ${python3.interpreter} ${component}/setup.py build --prefix $out $buildFlags
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${python3.interpreter} ${component}/setup.py install --prefix $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "GNAT Components Collection - Bindings to C libraries";
    homepage = "https://github.com/AdaCore/gnatcoll-bindings";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.sternenseemann ];
  };
}
