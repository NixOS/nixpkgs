{ lib , buildPythonPackage, fetchPypi, isPy27
, falcon
, pytestrunner
, requests
}:

buildPythonPackage rec {
  pname = "hug";
  version = "2.6.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0iamrzjy8z1xibynkgfl6cn2sbm66awxbp75b26pi32fc41d0k50";
  };

  nativeBuildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ falcon requests ];

  # tests are not shipped in the tarball
  doCheck = false;

  meta = with lib; {
    description = "A Python framework that makes developing APIs as simple as possible, but no simpler";
    homepage = https://github.com/timothycrosley/hug;
    license = licenses.mit;
  };

}
