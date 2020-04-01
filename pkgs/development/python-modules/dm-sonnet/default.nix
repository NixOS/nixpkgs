{ lib
, fetchFromGitHub
, buildBazelPackage
, buildPythonPackage
, git
, python
, six
, absl-py
, semantic-version
, contextlib2
, wrapt
, tensorflow
, tensorflow-probability
, tensorflow-estimator
}:

let
  version = "1.33";

  # first build all binaries and generate setup.py using bazel
  bazel-build = buildBazelPackage {
    name = "dm-sonnet-bazel-${version}";

    src = fetchFromGitHub {
      owner = "deepmind";
      repo = "sonnet";
      rev = "v${version}";
      sha256 = "1nqsja1s8jrkq6v1whgh7smk17313mjr9vs3k5c1m8px4yblzhqc";
    };

    nativeBuildInputs = [
      git # needed to fetch the bazel deps (protobuf in particular)
    ];

    # see https://github.com/deepmind/sonnet/blob/master/docs/INSTALL.md
    bazelTarget = ":install";

    fetchAttrs = {
      sha256 = "0wb2gh9ji8bgq4s9ci9x017dybxqzjhncpw33b1wjksm2yhbkvlz";
    };

    bazelFlags = [
      # https://github.com/deepmind/sonnet/issues/134
      "--incompatible_disable_deprecated_attr_params=false"
    ];

    buildAttrs = {
      preBuild = ''
        patchShebangs .
      '';

      installPhase = ''
        # do not generate a wheel, instead just copy the generated files to $out to be installed by buildPythonPackage
        sed -i 's,.*bdist_wheel.*,cp -rL . "$out"; exit 0,' bazel-bin/install

        # the target directory "dist" does not actually matter since we're not generating a wheel
        bazel-bin/install dist
      '';
    };
  };

# now use pip to install the package prepared by bazel
in buildPythonPackage {
  pname = "dm-sonnet";
  inherit version;

  src = bazel-build;

  propagatedBuildInputs = [
    six
    absl-py
    semantic-version
    contextlib2
    wrapt
    tensorflow
    tensorflow-probability
    tensorflow-estimator
  ];

  # not sure how to properly run the real test suite -- through bazel?
  checkPhase = ''
    ${python.interpreter} -c "import sonnet"
  '';

  meta = with lib; {
    description = "TensorFlow-based neural network library";
    homepage = https://sonnet.dev;
    license = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.linux;
  };
}
