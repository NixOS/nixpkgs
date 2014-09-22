{ kde, kdelibs, boost, python}:
kde {
  buildInputs = [ kdelibs boost boost.lib python ];

  cmakeFlags = "-DKIG_ENABLE_PYTHON_SCRIPTING=1";
  meta = {
    description = "KDE Interactive Geometry";
  };
}
