{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config

, enablePython ? false
, python3
}:

stdenv.mkDerivation rec {
  pname = "libplist";
  version = "2.2.0+date=2022-04-05";

  outputs = [ "bin" "dev" "out" ] ++ lib.optional enablePython "py";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "db93bae96d64140230ad050061632531644c46ad";
    hash = "sha256-8e/PFDhsyrOgmI3vLT1YhcROmbJgArDAJSe8Z2bZafo=";
  };

  postPatch = ''
    echo '${version}' > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = lib.optionals enablePython [
    python3
    python3.pkgs.cython
  ];

  configureFlags = lib.optionals (!enablePython) [
    "--without-cython"
  ];

  postFixup = lib.optionalString enablePython ''
    moveToOutput "lib/${python3.libPrefix}" "$py"
  '';

  meta = with lib; {
    description = "A library to handle Apple Property List format in binary or XML";
    homepage = "https://github.com/libimobiledevice/libplist";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ infinisil ];
    platforms = platforms.unix;
  };
}
