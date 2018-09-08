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
  version = "2.8";

  src = fetchFromGitHub {
     owner = "esa";
     repo = "pagmo2";
     rev = "v${version}";
     sha256 = "1xwxamcn3fkwr62jn6bkanrwy0cvsksf75hfwx4fvl56awnbz41z";
  };

  buildInputs = [ cmake eigen nlopt ipopt boost pagmo2 ];
  propagatedBuildInputs = [ numpy cloudpickle ipyparallel numba ];

  preBuild = ''
    cp -v -r $src/* .
    cmake -DCMAKE_INSTALL_PREFIX=$out -DPAGMO_BUILD_TESTS=no -DCMAKE_SYSTEM_NAME=Linux -DPagmo_DIR=${pagmo2} -DPAGMO_BUILD_PYGMO=yes -DPAGMO_BUILD_PAGMO=no -DPAGMO_WITH_EIGEN3=yes -DPAGMO_WITH_NLOPT=yes -DNLOPT_LIBRARY=${nlopt}/lib/libnlopt_cxx.so -DPAGMO_WITH_IPOPT=yes -DIPOPT=${ipopt}

    make install
    mv $out/lib/python*/site-packages/pygmo wheel
    cd wheel
  '';

  # dont do tests
  doCheck = false;

  meta = {
    description = "Parallel optimisation for Python";
    homepage = https://esa.github.io/pagmo2/;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
