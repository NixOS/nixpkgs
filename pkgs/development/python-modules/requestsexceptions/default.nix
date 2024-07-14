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
    hash = "sha256-sJXLx3YY8GbUWaArE3sCDDfan0bZsFdwQBnJ9326MGU=";
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
