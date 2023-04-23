{stdenv}:

let
  windir = "/cygdrive/c/WINDOWS";
in
{
  pkg = stdenv.mkDerivation rec {
    pname = "dotnetfx";
    version = "3.5";
    src = "${windir}/Microsoft.NET/Framework/v${version}";
    buildCommand = ''
      mkdir -p $out/bin
      ln -s $src/MSBuild.exe $out/bin
    '';
  };

  assembly20Path = "/cygdrive/c/WINDOWS/Microsoft.NET/Framework/v2.0.50727";

  wcfPath = "/cygdrive/c/WINDOWS/Microsoft.NET/Framework/v3.0/WINDOW~1";

  referenceAssembly30Path = "/cygdrive/c/PROGRA~1/REFERE~1/Microsoft/Framework/v3.0";

  referenceAssembly35Path = "/cygdrive/c/PROGRA~1/REFERE~1/Microsoft/Framework/v3.5";
}
