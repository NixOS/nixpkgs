{ stdenv, buildPythonPackage, python, pythonOlder, fetchFromGitHub, cmake, sip }:

buildPythonPackage rec {
  pname = "libsavitar";
  version = "4.1.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libSavitar";
    rev = version;
    sha256 = "132bgcvjkr61pzf244hwz8gxzpg1i50na4bkcipwnyxdravdkkgf";
  };

  postPatch = ''
    sed -i 's#''${Python3_SITELIB}#${placeholder "out"}/${python.sitePackages}#' cmake/SIPMacros.cmake
  '';

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ sip ];

  disabled = pythonOlder "3.4.0";

  meta = with stdenv.lib; {
    description = "C++ implementation of 3mf loading with SIP python bindings";
    homepage = https://github.com/Ultimaker/libSavitar;
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar orivej ];
  };
}
