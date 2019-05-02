{ lib
, fetchFromGitHub
, buildPythonPackage
, eigen
, nlopt
, ipopt
, boost
, pagmo2
, numpy
, cloudpickle
, ipyparallel
, numba
, python
}:

let
  propagatedBuildInputs = [ numpy cloudpickle ipyparallel numba ];

  pagmo2WithPython = pagmo2.overrideAttrs (oldAttrs: {
    cmakeFlags = oldAttrs.cmakeFlags ++ [
      "-DPAGMO_BUILD_PYGMO=yes"
      "-DPAGMO_BUILD_PAGMO=no"
      "-DPagmo_DIR=${pagmo2}"
    ];
    buildInputs = [ eigen nlopt ipopt boost pagmo2 ] ++ propagatedBuildInputs;
    postInstall = ''
      mv wheel $out
    '';
  });

in buildPythonPackage rec {
  pname = "pygmo";
  version = pagmo2WithPython.version;

  inherit propagatedBuildInputs;

  src = pagmo2WithPython;

  preBuild = ''
    mv ${python.sitePackages}/pygmo wheel
    cd wheel
  '';

  # dont do tests
  doCheck = false;

  meta = with lib; {
    description = "Parallel optimisation for Python";
    homepage = https://esa.github.io/pagmo2/;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.costrouc ];
  };
}
