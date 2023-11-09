{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, setuptools
, chardet
, click
, numpy
, openpyxl
, pandas
, pdfminer-six
, pypdf
, tabulate
, ghostscript
, matplotlib
, opencv4
, pytest-mpl
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "camelot-py";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "camelot-dev";
    repo = "camelot";
    rev = "refs/tags/v${version}";
    hash = "sha256-vR/oX3t2npPTrd7RM1GiZwryp88dlJ0fzSgPS36/QXw=";
  };

  patches = [
    (fetchpatch {
      name = "pandas_2-compatibility.patch";
      url = "https://github.com/camelot-dev/camelot/commit/44b4e6846ffda916b288d81f4e700dbb9e0e9ca9.patch";
      hash = "sha256-voHUXgdGbGfnUsfKPfG2tXedljrZwVk4ru9yuyXIZK8=";
    })
  ];

  # the exception is thrown because ctypes.util.find_library() is used to find the ghostscript,
  # but we don't need that exception
  postPatch = ''
    substituteInPlace camelot/backends/ghostscript_backend.py \
      --replace "if not self.installed():" "if False:"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    chardet
    click
    numpy
    openpyxl
    pandas
    pdfminer-six
    pypdf
    tabulate
    # it is an optional-dependencies, but necessary for minimal usage
  ] ++ passthru.optional-dependencies.base;

  passthru.optional-dependencies = {
    all = passthru.optional-dependencies.base ++ passthru.optional-dependencies.plot;
    base = [
      ghostscript
      opencv4
      # it is very wired to deal with a vendor poppler
      # also, it is an alternative backend to ghostscript, so there is no significant problem without it
      # pdftopng
    ];
    plot = [
      matplotlib
    ];
  };

  nativeCheckInputs = [
    pytest-mpl
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = ''
    substituteInPlace setup.cfg \
      --replace "--cov-config .coveragerc --cov-report term --cov-report xml --cov=camelot" ""
  '';

  disabledTests = [
    # touch the network
    "test_pages_poppler"
    "test_repr_poppler"
    "test_url_poppler"
    "test_pages_ghostscript"
    "test_url_ghostscript"

    # require pdftopng
    "test_grid_plot_poppler"
    "test_lattice_contour_plot_poppler"
    "test_joint_plot_poppler"
    "test_line_plot_poppler"

    # flaky tests that fail because of noise in the image
    "test_joint_plot_ghostscript"
    "test_lattice_contour_plot_ghostscript"
  ];

  pythonImportsCheck = [
    "camelot"
  ];

  meta = with lib; {
    description = "A Python library to extract tabular data from PDFs";
    homepage = "http://camelot-py.readthedocs.io";
    changelog = "https://github.com/camelot-dev/camelot/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ _2gn ];
  };
}
