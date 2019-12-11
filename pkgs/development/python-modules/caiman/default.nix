{ lib, buildPythonPackage, fetchFromGitHub
, bokeh
, coverage
, cython
, ffmpeg
, future
, h5py
, holoviews
, imageio
, ipykernel
, ipython
, ipyparallel
, jupyter
, matplotlib
, mypy
, nose
, numpy
, numpydoc
, opencv3
, peakutils
, pims
, pynwb
, pyqt5
, pyqtgraph
, qt5
, scikitimage
, scikitlearn
, scipy
, tensorflow
, tifffile
, tk
, tqdm
, yapf
}:

qt5.mkDerivationWith buildPythonPackage rec {
  pname = "caiman";
  version = "1.6.4";

  src = fetchFromGitHub {
      owner = "flatironinstitute";
      repo = pname;
      rev = "v"+version;
      sha256 = "12q5awr890pzpgpxfrf85034axwshv5bq9mxacrdc79278q4ghcc";
  };

  buildInputs = [
    ffmpeg
    qt5.qtbase
  ];

  separateDebugInfo = true;


  # for some reason, in default check phase, gcc and g++ are called a 2nd time and recompile
  # same programs. Tests fail as wrapQtAppsHook is not called

  # both checkPhases below result in segmentation fault
  # likewise, disabling tests and trying to `import caiman` in nix-shell also
  # segfaults
  # checkPhase = ''nosetests'';
  checkPhase = ''python caimanmanager.py test'';

  checkInputs = [
    nose
  ];

  propagatedBuildInputs = [
    bokeh
    coverage
    cython
    future
    h5py
    holoviews
    imageio
    ipykernel
    ipython
    ipyparallel
    jupyter
    matplotlib
    mypy
    nose
    numpy
    numpydoc
    opencv3
    peakutils
    pims
    pynwb
    pyqt5
    pyqtgraph
    scikitimage
    scikitlearn
    scipy
    tensorflow
    tifffile
    tk
    tqdm
    yapf
  ];

  meta = with lib; {
    homepage = "https://github.com/flatironinstitute/caiman";
    description = "Computational toolbox for large scale Calcium Imaging Analysis.";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tbenst ];
  };
}
