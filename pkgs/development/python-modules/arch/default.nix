{ lib
, buildPythonPackage
, fetchPypi
, cython
, matplotlib
, numpy
, property-cached
, python
, scipy
, statsmodels
, pandas
, pytest 
}:

buildPythonPackage rec {
  pname = "arch";
  version = "4.11";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "a3d5cd9086e7c44638286fbe46a4688a3668ab79400a1712c3ce43490be0c3bb";
  };

  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [ numpy property-cached python scipy statsmodels ];
  
  preBuild = ''
    ${python.interpreter} setup.py build_ext -i
  '';
    
  checkInputs = [ matplotlib pandas pytest ];

  # scipy.optimize has been changed in 1.4 which broke test_convergence_warning
  checkPhase = ''
    pytest arch/tests -k 'not test_convergence_warning'
  '';

  meta = with lib; {
    description = "Autoregressive Conditional Heteroskedasticity";
    homepage = "https://github.com/bashtage/arch";
    license = licenses.ncsa;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
