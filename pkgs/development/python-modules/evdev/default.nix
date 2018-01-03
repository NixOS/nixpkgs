{ lib, buildPythonPackage, isPy34, fetchurl, linuxHeaders }:

buildPythonPackage rec {
  version = "0.6.4";
  name = "evdev-${version}";
  disabled = isPy34;  # see http://bugs.python.org/issue21121

  src = fetchurl {
    url = "mirror://pypi/e/evdev/${name}.tar.gz";
    sha256 = "1wkag91s8j0f45jx5n619z354n8pz8in9krn81hp7hlkhi6p8s2j";
  };

  buildInputs = [ linuxHeaders ];

  patchPhase = "sed -e 's#/usr/include/linux/#${linuxHeaders}/include/linux/#g' -i setup.py";

  doCheck = false;

  meta = with lib; {
    description = "Provides bindings to the generic input event interface in Linux";
    homepage = http://pythonhosted.org/evdev;
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
