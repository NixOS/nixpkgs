{ lib
, buildPythonPackage
, hyperopt
, keras
, nnpdf
, psutil
, tensorflow
, validphys2
}:

buildPythonPackage rec {
  pname = "n3fit";
  version = "4.0";
  format = "setuptools";

  inherit (nnpdf) src;

  prePatch = ''
    cd n3fit
  '';

  postPatch = ''
    substituteInPlace src/n3fit/version.py \
      --replace '= __give_git()' '= "'$version'"'
  '';

  propagatedBuildInputs = [
    hyperopt
    keras
    psutil
    tensorflow
    validphys2
  ];

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH "$PYTHONPATH:$(toPythonPath "$out")"
    done
  '';

  doCheck = false; # no tests
  pythonImportsCheck = [ "n3fit" ];

  meta = with lib; {
    description = "NNPDF fitting framework";
    homepage = "https://docs.nnpdf.science";
    inherit (nnpdf.meta) license;
    maintainers = with maintainers; [ veprbl ];
  };
}
