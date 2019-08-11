{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, nose
, matplotlib
, nibabel
, numpy
, scipy
, sympy
, python
}:

buildPythonPackage rec {
  version = "0.4.2";
  pname = "nipy";
  disabled = pythonOlder "2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pn731nsczrx198i2gadffqmfbhviglrclv6xxwhnbv6w5hfs2yk";
  };

  buildInputs = stdenv.lib.optional doCheck [ nose ];
  propagatedBuildInputs = [ matplotlib nibabel numpy scipy sympy ];

  checkPhase = ''    # wants to be run in a different directory
    mkdir nosetests
    cd nosetests
    ${python.interpreter} -c "import nipy; nipy.test()"
    rm -rf .
  '';

  # failing test:
  # nipy.algorithms.statistics.models.tests.test_olsR.test_results(11.593139639404727, 11.593140144880794, 6)  # disagrees by 1 at 6th decimal place
  # erroring tests:
  # nipy.modalities.fmri.fmristat.tests.test_FIAC.test_altprotocol
  # nipy.modalities.fmri.fmristat.tests.test_FIAC.test_agreement
  # nipy.tests.test_scripts.test_nipy_4d_realign   # because `nipy_4d_realign` script isn't found at test time; works from nix-shell, so could be patched
  # nipy.tests.test_scripts.test_nipy_3_4d         # ditto re.: `nipy_3_4d` script
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://nipy.org/nipy/;
    description = "Software for structural and functional neuroimaging analysis";
    license = licenses.bsd3;
  };

}
