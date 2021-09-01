{ lib
, isPy3k
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, networkx
, jinja2
, ipython
, jsonpickle
, numpy }:

buildPythonPackage rec {
  pname = "pyvis";
  version = "unstable-2021-04-29";

  # We use unstable, as test are failing for 0.1.9
  src = fetchFromGitHub {
    owner = "WestHealth";
    repo = pname;
    rev = "4c521302abf9725dcbe7f59962baf85360b2718d";
    sha256 = "sha256-DYbHQpxtSfiLbzmBGclym/ChM0WLBzSEC/3phDTtGY8=";
  };

  patches = [
    # Remove when https://github.com/WestHealth/pyvis/pull/101 is merged.
    (fetchpatch {
      url = "https://github.com/WestHealth/pyvis/commit/158a34de45f970b17ffd746c6e705b89128e2445.patch";
      sha256 = "sha256-zK72nrnn5YLGNW6PKYUyHry5ORCdt1T1oH6n1X64DKg=";
    })
  ];

  propagatedBuildInputs = [ networkx jinja2 ipython jsonpickle ];

  checkInputs = [ numpy ];

  pythonImportsCheck = [ "pyvis" ];

  meta = with lib; {
    homepage = "https://github.com/WestHealth/pyvis";
    description = "Python package for creating and visualizing interactive network graphs";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
  };
}
