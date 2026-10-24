{ lib
, buildPythonPackage
, fetchPypi
, wxPython_4_2
, pytest
}:

buildPythonPackage rec {
    pname = "re-wx";
    version = "0.0.10";

    src = fetchPypi {
        inherit pname version;
        sha256 = "750d28e1987cb58ea580bee3b63178f5a1ee483a32682f95455628fe7429117e";
    };

    buildInputs = [ wxPython_4_2 ];

    doCheck = true;
    checkInputs = [ pytest ];
    checkPhase = ''
      # py.test tests/test_components/test_gauge.py # ModuleNotFoundError: No module named 'pip._vendor.contextlib2'
      # py.test tests/test_components/test_staticbitmap.py # ModuleNotFoundError: No module named 'pip._vendor.contextlib2'
      # py.test tests/test_components/test_textctrl.py # SystemExit: Unable to access the X Display
      py.test tests/test_create_element.py
      # py.test tests/test_nested_components.py # SystemExit: Unable to access the X Display
      # py.test tests/test_widgets.py # SystemExit: Unable to access the X Display
    '';

    pythonImportsCheck = [
    "rewx"
    "rewx.components"
    "rewx.widgets"
    ];

  meta = with lib; {
    # for python v3.10.6, re-wx fails during linking with
    #
    #     python3.10-wxPython-4.1.1/lib/python3.10/site-packages/wx/svg/_nanosvg.cpython-310-x86_64-linux-gnu.so: undefined symbol: _PyGen_Send
    #
    # https://github.com/wxWidgets/Phoenix/issues/2016
    # https://github.com/cython/cython/issues/3876
    #
    # This is fixed in wxPython v4.2.0.
    # https://github.com/wxWidgets/Phoenix/issues/2016
    #
    # So Python v3.10 requires wxPython v4.2.0
    description = "Modern declarative desktop applications with a wxPython virtualdom";
    homepage = "https://github.com/chriskiehl/re-wx";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

