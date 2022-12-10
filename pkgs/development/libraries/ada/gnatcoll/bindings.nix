{ stdenv
, lib
, fetchFromGitHub
, gnat
, gprbuild
, gnatcoll-core
, component
# component dependencies
, gmp
, libiconv
, xz
, gcc-unwrapped
, readline
, zlib
, python3
, ncurses
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
  version = "23.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "gnatcoll-bindings";
    rev = "v${version}";
    sha256 = "1jnnfsvll4jh6ip0fww4mh2cm61h7dzpxz3zaa2psrc1w54x34nn";
  };

  nativeBuildInputs = [
    gprbuild
    gnat
    python3
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
