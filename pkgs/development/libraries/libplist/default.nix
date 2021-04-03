{ lib, stdenv, autoreconfHook, fetchFromGitHub, pkg-config, enablePython ? false, python ? null, glib }:

stdenv.mkDerivation rec {
  pname = "libplist";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = version;
    sha256 = "1vxhpjxniybqsg5wcygmdmr5dv7p2zb34dqnd3bi813rnnzsdjm6";
  };

  outputs = ["bin" "dev" "out" ] ++ lib.optional enablePython "py";

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ] ++ lib.optionals enablePython [
    python
    python.pkgs.cython
  ];

  configureFlags = lib.optionals (!enablePython) [
    "--without-cython"
  ];

  propagatedBuildInputs = [ glib ];

  postFixup = lib.optionalString enablePython ''
    moveToOutput "lib/${python.libPrefix}" "$py"
  '';

  meta = with lib; {
    description = "A library to handle Apple Property List format in binary or XML";
    homepage = "https://github.com/libimobiledevice/libplist";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ infinisil ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
