{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbr,
}:

buildPythonPackage rec {
  pname = "requestsexceptions";
  version = "1.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065";
  };

  propagatedBuildInputs = [ pbr ];

  # upstream hacking package is not required for functional testing
  patchPhase = ''
    sed -i '/^hacking/d' test-requirements.txt
  '';

  meta = with lib; {
    description = "Import exceptions from potentially bundled packages in requests";
    homepage = "https://pypi.python.org/pypi/requestsexceptions";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu ];
    platforms = platforms.all;
  };
}
