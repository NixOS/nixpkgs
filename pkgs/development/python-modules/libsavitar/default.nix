{ lib, buildPythonPackage, python, pythonOlder, fetchFromGitHub, cmake, sip }:

buildPythonPackage rec {
  pname = "libsavitar";
  version = "5.0.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libSavitar";
    rev = version;
    sha256 = "05c0y2wmn094vnd3aymnwishf74l7pyal0fnwf4lhs6i2y59km38";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ sip ];

  cmakeFlags = [
    # The upstream code checks for an exact python version and errors out
    # if we don't have that and do not pass `Python_VERSION` explicitly:
    #     https://github.com/Ultimaker/libSavitar/commit/a7ee88779574769e8c4cd82281f96d53fc4f742a#diff-1e7de1ae2d059d21e1dd75d5812d5a34b0222cef273b7c3a2af62eb747f9d20aR27
    "-DPython_VERSION=${python.pythonVersion}"
    # Set install location to not be the global Python install dir
    # (which is read-only in the nix store); see:
    "-DPython_SITELIB_LOCAL=${placeholder "out"}/${python.sitePackages}"
  ];

  disabled = pythonOlder "3.4.0";

  meta = with lib; {
    description = "C++ implementation of 3mf loading with SIP python bindings";
    homepage = "https://github.com/Ultimaker/libSavitar";
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar orivej gebner ];
  };
}
