{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "imagesize";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3832918bc3c66617f92e35f5d70729187676313caa60c187eb0f28b8fe5e3b5";
  };

  meta = with stdenv.lib; {
    description = "Getting image size from png/jpeg/jpeg2000/gif file";
    homepage = https://github.com/shibukawa/imagesize_py;
    license = with licenses; [ mit ];
  };

}
