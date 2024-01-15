{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, isPy3k
, python
}:

buildPythonPackage rec {
  version = "0.99.2dev-384-2b73caca";
  format = "setuptools";
  pname = "kaa-base";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k3zzz84wzz9q1fl3vvqr2ys96z9pcf4viq9q6s2a63zaysmcfd2";
  };

  doCheck = false;

  disabled = isPyPy || isPy3k;

  # Same as in buildPythonPackage except that it does not pass --old-and-unmanageable
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/${python.libPrefix}/site-packages"

    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --prefix="$out"

    eapth="$out/lib/${python.libPrefix}"/site-packages/easy-install.pth
    if [ -e "$eapth" ]; then
    mv "$eapth" $(dirname "$eapth")/${pname}-${version}.pth
    fi

    rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*

    runHook postInstall
  '';

  meta = with lib; {
    description = "Generic application framework, providing the foundation for other modules";
    homepage = "https://github.com/freevo/kaa-base";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
  };

}
