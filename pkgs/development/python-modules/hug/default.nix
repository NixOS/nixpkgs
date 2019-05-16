{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, falcon
, requests
}:

buildPythonPackage rec {
  pname = "hug";
  version = "2.4.8";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b33904660d07df3a6a998a52d1a36e2855e56dc9ffc4eddb2158e32d1ce7621";
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
