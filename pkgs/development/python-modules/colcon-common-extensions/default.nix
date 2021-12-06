{ lib, fetchgit, buildPythonPackage, colcon-argcomplete, colcon-bash, colcon-cd, colcon-cmake, colcon-core, colcon-defaults, colcon-devtools, colcon-library-path, colcon-metadata, colcon-notification, colcon-output, colcon-package-information, colcon-package-selection, colcon-parallel-executor, colcon-powershell, colcon-python-setup-py, colcon-recursive-crawl, colcon-ros, colcon-test-result, colcon-zsh }:

buildPythonPackage rec {
  pname = "colcon-common-extensions";
  version = "0.2.1";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-common-extensions.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "IK9vsCa1xor5Ztas2ZH1GU06OLHu7U92R5W4kynJQCc=";
  };

  propagatedBuildInputs = [ colcon-argcomplete colcon-bash colcon-cd colcon-cmake colcon-core colcon-defaults colcon-devtools colcon-library-path colcon-metadata colcon-notification colcon-output colcon-package-information colcon-package-selection colcon-parallel-executor colcon-powershell colcon-python-setup-py colcon-recursive-crawl colcon-ros colcon-test-result colcon-zsh ];

  # There are no tests.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-common-extensions";
    description = "A meta package aggregating colcon-core as well as a set of common extensions.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
