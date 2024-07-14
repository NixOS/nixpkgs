{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  pyusb,
  pyserial,
}:

buildPythonPackage rec {
  pname = "facedancer";
  version = "2019.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oNYp6rDQNTYx6z310JkIb8WSs5YvNWlJuY8uPR21HP4=";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [
    pyusb
    pyserial
  ];

  preBuild = ''
    echo "$version" > VERSION
  '';

  meta = with lib; {
    description = "library for emulating usb devices";
    homepage = "https://greatscottgadgets.com/greatfet/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mog ];
  };
}
