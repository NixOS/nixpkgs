{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, falcon
, requests
}:

buildPythonPackage rec {
  pname = "hug";
  version = "2.1.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "93325e13706594933a9afb0d4f0b0748134494299038f07df41152baf6f89f4c";
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
