{ stdenv, fetchurl, buildPythonPackage, pip, pytest, click, six, first
, setuptools_scm, git, glibcLocales, mock }:

buildPythonPackage rec {
  pname = "pip-tools";
  version = "2.0.1";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/p/pip-tools/${name}.tar.gz";
    sha256 = "81abea4ba206051ddaf90854b7302849002fdd0084450d2dd7f5c44a6d0ddf16";
  };

  LC_ALL = "en_US.UTF-8";
  checkInputs = [ pytest git glibcLocales mock ];
  propagatedBuildInputs = [ pip click six first setuptools_scm ];

  disabledTests = stdenv.lib.concatMapStringsSep " and " (s: "not " + s) [
    # Depend on network tests:
    "test_editable_package_vcs"
    "test_generate_hashes_all_platforms"
    "test_generate_hashes_without_interfering_with_each_other"
    "test_realistic_complex_sub_dependencies"
    "test_generate_hashes_with_editable"
    "test_filter_pip_markes"
    "test_get_hashes_local_repository_cache_miss"
    # Expect specific version of "six":
    "test_editable_package"
    "test_input_file_without_extension"
    "test_locally_available_editable_package_is_not_archived_in_cache_dir"
  ];

  checkPhase = ''
    export HOME=$(mktemp -d) VIRTUAL_ENV=1
    tests_without_network_access="
      not test_realistic_complex_sub_dependencies
      and not test_editable_package_vcs
      and not test_generate_hashes_all_platforms
      and not test_generate_hashes_without_interfering_with_each_other
    "
    py.test -k "${disabledTests}"
  '';

  meta = with stdenv.lib; {
    description = "Keeps your pinned dependencies fresh";
    homepage = https://github.com/jazzband/pip-tools/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
