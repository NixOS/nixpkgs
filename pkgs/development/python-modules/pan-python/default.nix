{
  lib,
  buildPythonPackage,
  fetchurl,
}:

buildPythonPackage rec {
  pname = "pan-python";
  version = "0.25.0";
  format = "wheel";

  # fetchPypi doesn't appear to work, possibly because the uploaded archives on PyPI
  # are named (notice '_' vs. '-'):
  #  - pan-python-0.25.0.tar.gz
  #  - pan_python-0.25.0-py3-none-any.whl
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/68/b0/0af75e586869bc5eee67e75472771e820189cbedbdde619353191a2828b7/pan_python-0.25.0-py3-none-any.whl";
    hash = "sha256-IWqXsFORXzo8n+J39ZaqAK1vD1uIxy3idtt1+Sq5x+0=";
  };

  pythonImportsCheck = [ "pan" ];

  meta = {
    description = "Python package for Palo Alto Networks Next-Generation Firewalls, WildFire and AutoFocus";
    homepage = "https://github.com/kevinsteves/pan-python";
    changelog = "https://github.com/kevinsteves/pan-python/releases/tag/v${version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
