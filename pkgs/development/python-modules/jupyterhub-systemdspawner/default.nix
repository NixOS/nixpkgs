{ lib
, buildPythonPackage
, fetchPypi
, jupyterhub
, tornado
, bash
}:

buildPythonPackage rec {
  pname = "jupyterhub-systemdspawner";
  version = "0.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "080dd9cd9292266dad35d1efc7aa1af0ed6993d15eadc79bd959d1ee273d1923";
  };

  propagatedBuildInputs = [
    jupyterhub
    tornado
  ];

  postPatch = ''
    substituteInPlace systemdspawner/systemd.py \
      --replace "/bin/bash" "${bash}/bin/bash"

    substituteInPlace systemdspawner/systemdspawner.py \
      --replace "/bin/bash" "${bash}/bin/bash"
  '';

  meta = with lib; {
    description = "JupyterHub Spawner using systemd for resource isolation";
    homepage = "https://github.com/jupyterhub/systemdspawner";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
