{
  lib,
  stdenv,
  buildPythonPackage,
  python,
  fetchPypi,
}:

let
  format = "wheel";
  pyShortVersion = "cp" + builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  platforms = rec {
    aarch64-darwin =
      if pyShortVersion == "cp313" then "macosx_10_13_universal2" else "macosx_10_9_universal2";
    aarch64-linux = "manylinux2014_aarch64.manylinux_2_17_aarch64";
    x86_64-darwin = aarch64-darwin;
    x86_64-linux = "manylinux2014_x86_64.manylinux_2_17_x86_64";
  };
  platform = platforms.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  hashes = rec {
    cp312-aarch64-darwin = "sha256-i/0ygF6PxOotAlO1vq7yx2NXAxbyah9PLIbLqg6zqNc=";
    cp312-aarch64-linux = "sha256-WvK9RiY4T/xwDCmvDh3WnK/m9tvW78045eMoc6RvPRI=";
    cp312-x86_64-darwin = cp312-aarch64-darwin;
    cp312-x86_64-linux = "sha256-ER0yOTo5o+Ld1erRdScx04izxoW3NVDGsMqaRdlUw2Q=";
    cp313-aarch64-darwin = "sha256-V5HcmwKfBrMY1U4N+gf1yWiMJ+XHH3pUvNqv20wJBek=";
    cp313-aarch64-linux = "sha256-s8rr72p8a6I1WYcqtz3NgEDHFW74DN4LWRGLvf0k53k=";
    cp313-x86_64-darwin = cp313-aarch64-darwin;
    cp313-x86_64-linux = "sha256-JAqrYPz7/lhvRW1uy8yOyjtapf/nF+agjEHIKWQCYTc=";
  };
  hash =
    hashes."${pyShortVersion}-${stdenv.system}"
      or (throw "Unsupported Python version: ${python.pythonVersion}");
in
buildPythonPackage rec {
  pname = "gurobipy";
  version = "12.0.2";
  inherit format;

  src = fetchPypi {
    inherit pname version;
    python = pyShortVersion;
    abi = pyShortVersion;
    dist = pyShortVersion;
    inherit format platform hash;
  };

  pythonImportsCheck = [ "gurobipy" ];

  meta = {
    description = "Python interface to Gurobi";
    homepage = "https://www.gurobi.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = builtins.attrNames platforms;
  };
}
