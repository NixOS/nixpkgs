{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  # build inputs
  numpy,
  yacs,
  pyyaml,
  tqdm,
  termcolor,
  pillow,
  tabulate,
  iopath,
  shapely,
  # check inputs
  torch,
}:
let
  pname = "fvcore";
  version = "0.1.5.post20221221";
  optional-dependencies = {
    all = [ shapely ];
  };
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8vsLuQVyrmUcEceOIEk+0ZsiQFUKfku7LW3oe90DeGA=";
  };

  propagatedBuildInputs = [
    numpy
    yacs
    pyyaml
    tqdm
    termcolor
    pillow
    tabulate
    iopath
  ];

  nativeCheckInputs = [ torch ];

  # TypeError: flop_count() missing 2 required positional arguments: 'model' and 'inputs'
  doCheck = false;

  pythonImportsCheck = [ "fvcore" ];

  optional-dependencies = optional-dependencies;

  meta = with lib; {
    description = "Collection of common code that's shared among different research projects in FAIR computer vision team";
    homepage = "https://github.com/facebookresearch/fvcore";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
