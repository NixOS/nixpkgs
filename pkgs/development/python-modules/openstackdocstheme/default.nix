{ lib, buildPythonPackage, fetchPypi, python
, pbr
, dulwich
, sphinx
}:
buildPythonPackage rec {
  pname = "openstackdocstheme";
  version = "1.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jnj8yi1lq4piapy57q6y48qzld1r74lsqrbvn97l13ib43hs93g";
  };

  propagatedBuildInputs = [ pbr dulwich ];

  checkInputs = [ sphinx ];

  preCheck = ''
    sed -i '/hacking/d' test-requirements.txt
  '';


  meta = with lib;{
    homepage = https://github.com/openstack/openstackdocstheme;
    description = "Sphinx theme for RST-sourced documentation published to docs.openstack.org";
    license = licenses.asl20;
  };
}
