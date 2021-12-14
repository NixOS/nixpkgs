{ autoPatchelfHook
, buildPythonPackage
, fetchPypi
, isPy39
, lib
, six
, stdenv
}:

buildPythonPackage rec {
  pname = "dm-tree";
  version = "0.1.6";
  format = "wheel";

  # At the time of writing (8/19/21), there are releases for 3.6-3.9. Supporting
  # all of them is a pain, so we focus on 3.9, the current nixpkgs python3
  # version.
  disabled = !isPy39;

  src = fetchPypi {
    inherit version format;
    sha256 = "1f71dy5xa5ywa5chbdhpdf8k0w1v9cvpn3qyk8nnjm79j90la9c4";
    pname = "dm_tree";
    dist = "cp39";
    python = "cp39";
    abi = "cp39";
    platform = "manylinux_2_24_x86_64";
  };

  # Prebuilt wheels are dynamically linked against things that nix can't find.
  # Run `autoPatchelfHook` to automagically fix them.
  nativeBuildInputs = [ autoPatchelfHook ];
  # Dynamic link dependencies
  buildInputs = [ stdenv.cc.cc ];

  propagatedBuildInputs = [ six ];

  pythonImportsCheck = [ "tree" ];

  meta = with lib; {
    description = "Tree is a library for working with nested data structures.";
    homepage    = "https://github.com/deepmind/tree";
    license     = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
    platforms = [ "x86_64-linux" ];
  };
}
