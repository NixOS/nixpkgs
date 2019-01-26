{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, falcon
, requests
}:

buildPythonPackage rec {
  pname = "hug";
  version = "2.4.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b633ebbed95f4c264a745cf91450007fe7004e1eaa5b02bf9b3ad28fdd62d08";
  };

  propagatedBuildInputs = [ falcon requests ];

  # tests are not shipped in the tarball
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Python framework that makes developing APIs as simple as possible, but no simpler";
    homepage = https://github.com/timothycrosley/hug;
    license = licenses.mit;
  };

}
