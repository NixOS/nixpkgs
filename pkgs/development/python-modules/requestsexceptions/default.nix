{ lib, buildPythonPackage, fetchPypi, pbr }:

buildPythonPackage rec {
  pname = "requestsexceptions";
  version = "1.3.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gim00vi7vfq16y8b9m1vpy01grqvrdrbh88jb98qx6n6sk1n54g";
  };

  propagatedBuildInputs = [ pbr ];

  # upstream hacking package is not required for functional testing
  patchPhase = ''
    sed -i '/^hacking/d' test-requirements.txt
  '';

  meta = with lib; {
    description = "Import exceptions from potentially bundled packages in requests.";
    homepage = "https://pypi.python.org/pypi/requestsexceptions";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu ];
    platforms = platforms.all;
  };
}
