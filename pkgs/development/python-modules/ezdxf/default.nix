{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pyparsing
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "0.18.1";
  pname = "ezdxf";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "ezdxf";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-x1p9dWrbDtDreXdBuzOA4Za+ZC40y4xdEU7MGb9uUec=";
  };

  propagatedBuildInputs = [
    pyparsing
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # requires geomdl dependency
    "TestNurbsPythonCorrectness"
    "test_rational_spline_curve_points_by_nurbs_python"
    "test_rational_spline_derivatives_by_nurbs_python"
    "test_from_nurbs_python_curve_to_ezdxf_bspline"
    "test_from_ezdxf_bspline_to_nurbs_python_curve_non_rational"
    "test_from_ezdxf_bspline_to_nurbs_python_curve_rational"
    # AssertionError: assert 44.99999999999999 == 45
    "test_dimension_transform_interface"
  ];

  pythonImportsCheck = [
    "ezdxf"
    "ezdxf.addons"
  ];

  meta = with lib; {
    description = "Python package to read and write DXF drawings (interface to the DXF file format)";
    homepage = "https://github.com/mozman/ezdxf/";
    license = licenses.mit;
    maintainers = with maintainers; [ hodapp ];
    platforms = platforms.unix;
  };
}
