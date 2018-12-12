{ lib
, fetchFromGitHub
, buildPythonPackage
, cmake
, eigen
, nlopt
, ipopt
, boost
, pagmo2
, numpy
, cloudpickle
, ipyparallel
, numba
}:

buildPythonPackage rec {
  pname = "pygmo";
  version = pagmo2.version;

  src = pagmo2.src;

  buildInputs = [ cmake eigen nlopt ipopt boost pagmo2 ];
  propagatedBuildInputs = [ numpy cloudpickle ipyparallel numba ];

  preBuild = ''
    cmake -DCMAKE_INSTALL_PREFIX=$out \
      -DPagmo_DIR=${pagmo2} \
      -DPAGMO_BUILD_PYGMO=yes \
      -DPAGMO_BUILD_PAGMO=no \
      -DNLOPT_LIBRARY=${nlopt}/lib/libnlopt.so

    make install
    mv $out/lib/python*/site-packages/pygmo wheel
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
