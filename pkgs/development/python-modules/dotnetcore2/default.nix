{ stdenv, lib, buildPythonPackage, fetchPypi, python, isPy27
, dotnet-sdk
, substituteAll
, distro
, unzip
}:

buildPythonPackage rec {
  pname = "dotnetcore2";
  version = "2.1.14";
  format = "wheel";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    platform = "manylinux1_x86_64";
    sha256 = "0dxp9a73ncjylc09bjwq81fgj5ysk1yi27l8ka5f98121k1kmn6q";
  };

  nativeBuildInputs = [ unzip ];

  propagatedBuildInputs = [ distro ];

  # needed to apply patches
  prePatch = ''
    unzip dist/dotnet*
  '';

  patches = [
    ( substituteAll {
        src = ./runtime.patch;
        dotnet = dotnet-sdk;
      }
    )
  ];

  # remove bin, which has a broken dotnetcore installation
  installPhase = ''
    rm -rf dotnetcore2/bin
    mkdir -p $out/${python.sitePackages}/
    cp -r dotnetcore2 $out/${python.sitePackages}/
  '';

  # no tests, ensure it's one useful function works
  checkPhase = ''
    rm -r dotnetcore2 # avoid importing local directory
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
    ${python.interpreter} -c 'from dotnetcore2 import runtime; print(runtime.get_runtime_path()); runtime.ensure_dependencies()'
  '';

  meta = with lib; {
    description = "DotNet Core runtime";
    homepage = "https://github.com/dotnet/core";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jonringer ];
  };
}
