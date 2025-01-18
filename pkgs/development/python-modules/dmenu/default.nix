{
  buildPythonPackage,
  lib,
  fetchPypi,
  dmenu,
}:

buildPythonPackage rec {
  pname = "dmenu-python";
  version = "0.2.1";

  src = fetchPypi {
    inherit version;
    pname = "dmenu";
    sha256 = "06v2fq0ciallbib7sbk4kncj0n3gdqp1kz8n5k2669x49wyh34wm";
  };

  propagatedBuildInputs = [ dmenu ];

  # No tests existing
  doCheck = false;

  meta = with lib; {
    description = "Python wrapper for dmenu";
    homepage = "https://dmenu.readthedocs.io";
    license = licenses.mit;
    maintainers = [ maintainers.nico202 ];
  };
}
