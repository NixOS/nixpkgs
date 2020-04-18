{ stdenv
, buildPythonPackage
, pyopenssl
, pkgs
, isPy3k
, python
}:

buildPythonPackage {
  pname = "deskcon";
  version = "0.3";
  disabled = isPy3k;

  src = pkgs.fetchFromGitHub {
    owner= "screenfreeze";
    repo = "deskcon-desktop";
    rev = "267804122188fa79c37f2b21f54fe05c898610e6";
    sha256 ="0i1dd85ls6n14m9q7lkympms1w3x0pqyaxvalq82s4xnjdv585j3";
  };

  phases = [ "unpackPhase" "installPhase" ];

  pythonPath = [ pyopenssl pkgs.gtk3 ];

  installPhase = ''
    substituteInPlace server/deskcon-server --replace "python2" "python"

    mkdir -p $out/bin
    mkdir -p $out/lib/${python.libPrefix}/site-packages
    cp -r "server/"* $out/lib/${python.libPrefix}/site-packages
    mv $out/lib/${python.libPrefix}/site-packages/deskcon-server $out/bin/deskcon-server

    wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    description = "Integrates an Android device into a desktop";
    homepage = "https://github.com/screenfreeze/deskcon-desktop";
    license = licenses.gpl3;
  };

}
