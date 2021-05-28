{ lib, buildPythonPackage, fetchPypi
, fonttools
, pytest, pytestrunner
}:

buildPythonPackage rec {
  pname = "fontMath";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09xdqdjyjlx5k9ymi36d7hkgvn55zzjzd65l2yqidkfazlmh14ss";
    extension = "zip";
  };

  propagatedBuildInputs = [ fonttools ];
  checkInputs = [ pytest pytestrunner ];

  meta = with lib; {
    description = "A collection of objects that implement fast font, glyph, etc. math";
    homepage = "https://github.com/robotools/fontMath/";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
