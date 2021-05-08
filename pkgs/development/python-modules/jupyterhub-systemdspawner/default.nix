{ lib
, buildPythonPackage
, fetchPypi
, jupyterhub
, tornado
, bash
}:

buildPythonPackage rec {
  pname = "jupyterhub-systemdspawner";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6e2d981657aa5d3794abb89b1650d056524158a3d0f0f706007cae9b6dbeb2b";
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

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "JupyterHub Spawner using systemd for resource isolation";
    homepage = "https://github.com/jupyterhub/systemdspawner";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
