{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  callPackage,
  fetchurl,
  autoPatchelfHook,
  bash,
  dejavu_fonts,
  expat,
  fontconfig,
  lato,
  libGL,
  makeWrapper,
  nspr,
  nss,
  sqlite,
}:

buildPythonPackage rec {
  pname = "kaleido";
  version = "0.2.1";
  format = "wheel";

  src =
    {
      # This library is so cursed that I have to use fetchurl instead of fetchPypi. I am not happy.
      x86_64-linux = fetchurl {
        url = "https://files.pythonhosted.org/packages/py2.py3/k/kaleido/kaleido-${version}-py2.py3-none-manylinux1_x86_64.whl";
        hash = "sha256-qiHPG/HHj4+lCp99ReEAPDh709b+CnZ8+780S5W9w6g=";
      };
      aarch64-linux = fetchurl {
        url = "https://files.pythonhosted.org/packages/py2.py3/k/kaleido/kaleido-${version}-py2.py3-none-manylinux2014_aarch64.whl";
        hash = "sha256-hFgZhEyAgslGnZwX5CYh+/hcKyN++KhuyKhSf5i2USo=";
      };
      x86_64-darwin = fetchurl {
        url = "https://files.pythonhosted.org/packages/py2.py3/k/kaleido/kaleido-${version}-py2.py3-none-macosx_10_11_x86_64.whl";
        hash = "sha256-ym9z5/8AquvyhD9z8dO6zeGTDvUEEJP+drg6FXhQSac=";
      };
      aarch64-darwin = fetchurl {
        url = "https://files.pythonhosted.org/packages/py2.py3/k/kaleido/kaleido-${version}-py2.py3-none-macosx_11_0_arm64.whl";
        hash = "sha256-u5pdH3EDV9XUMu4kDvZlim0STD5hCTWBe0tC2px4fAU=";
      };
    }
    ."${stdenv.hostPlatform.system}"
      or (throw "Unsupported system for ${pname}: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = (lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ]) ++ [
    makeWrapper
  ];
  buildInputs = [
    bash
    dejavu_fonts
    expat
    fontconfig
    lato
    libGL
    nspr
    nss
    sqlite
  ];

  pythonImportsCheck = [ "kaleido" ];

  postInstall = ''
    # Expose kaleido binary
    mkdir -p $out/bin
    ln -s $out/${python.sitePackages}/kaleido/executable/bin/kaleido $out/bin/kaleido

    # Relace bundled libraries with nixpkgs-packaged libraries
    rm -rf $out/${python.sitePackages}/kaleido/executable/lib
    mkdir -p $out/${python.sitePackages}/kaleido/executable/lib
    ln -s ${expat}/lib/* $out/${python.sitePackages}/kaleido/executable/lib/
    ln -s ${nspr}/lib/* $out/${python.sitePackages}/kaleido/executable/lib/
    ln -s ${nss}/lib/* $out/${python.sitePackages}/kaleido/executable/lib/
    ln -s ${sqlite}/lib/* $out/${python.sitePackages}/kaleido/executable/lib/

    # Replace bundled font configuration with nixpkgs-packaged font configuration
    rm -rf $out/${python.sitePackages}/kaleido/executable/etc/fonts
    mkdir -p $out/${python.sitePackages}/kaleido/executable/etc/fonts/conf.d
    ln -s ${fontconfig.out}/etc/fonts/fonts.conf $out/${python.sitePackages}/kaleido/executable/etc/fonts/
    ln -s ${fontconfig.out}/etc/fonts/conf.d/* $out/${python.sitePackages}/kaleido/executable/etc/fonts/conf.d/
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # Replace bundled swiftshader with libGL
    rm -rf $out/${python.sitePackages}/kaleido/executable/bin/swiftshader
    ln -s ${libGL}/lib $out/${python.sitePackages}/kaleido/executable/bin/swiftshader
  '';

  passthru.tests = lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
    kaleido = callPackage ./tests.nix { };
  };

  meta = {
    description = "Fast static image export for web-based visualization libraries with zero dependencies";
    homepage = "https://github.com/plotly/Kaleido";
    changelog = "https://github.com/plotly/Kaleido/releases";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ]; # Trust me, I'm not happy. But after literal hours of trying to reverse-engineer their build system and getting nowhere, I'll use the stupid binaries >:(
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
