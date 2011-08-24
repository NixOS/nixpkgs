{ kde, kdelibs, boost, python}:
kde {
  buildInputs = [ kdelibs boost python ];

  cmakeFlags = ''
    -DBOOST_PYTHON_INCLUDES:PATH=${boost}/include;${python}/include/${python.libPrefix}
    -DBOOST_PYTHON_LIBS=boost_python;${python.libPrefix} -DKIG_ENABLE_PYTHON_SCRIPTING=1
    '';
  meta = {
    description = "KDE Interactive Geometry";
  };
}
