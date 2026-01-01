{
  lib,
  buildPythonPackage,
  fetchPypi,
  mitmproxy-rs,
}:

buildPythonPackage rec {
  pname = "mitmproxy-macos";
  inherit (mitmproxy-rs) version;
  format = "wheel";

<<<<<<< HEAD
  # Note: if this isn't downloading, its because mitmproxy-rs updated without also updating this.
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchPypi {
    pname = "mitmproxy_macos";
    inherit version;
    format = "wheel";
    dist = "py3";
    python = "py3";
<<<<<<< HEAD
    hash = "sha256-baAfEY4hEN3wOEicgE53gY71IX003JYFyyZaNJ7U8UA=";
=======
    hash = "sha256-NArp10yhERk7Hhw5fIU+ekbupyldyzpLQdKgebiUpOM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # repo has no python tests
  doCheck = false;

  pythonImportsCheck = [ "mitmproxy_macos" ];

  meta = {
    inherit (mitmproxy-rs.meta) changelog license maintainers;
    description = "MacOS Rust bits in mitmproxy";
    homepage = "https://github.com/mitmproxy/mitmproxy_rs/tree/main/mitmproxy-macos";
    platforms = lib.platforms.darwin;
<<<<<<< HEAD
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
=======
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
