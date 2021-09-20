{ lib
, buildPythonPackage
, fetchurl
, python
, stdenv
}:

# Links taken from https://pypi.org/simple/py-slvs/
let urls =
  {
    x86_64-darwin = {
      "3.9" = {
        url = "https://files.pythonhosted.org/packages/9a/c0/a8a37650c4e558b5ab70477e56e420d68084af31d851100dda88e1f7ba7c/py_slvs-1.0.1-cp39-cp39-macosx_10_9_x86_64.whl";
        sha256 = "f1287df958e0af64373af1be1ff91c0fa601667ee44b2a046f3618dd51adcd4b";
      };
      "3.8" = {
        url = "https://files.pythonhosted.org/packages/95/4c/70d5ee81220e6c8cad2f57b063c54282d98340847f165e326ec652d0f40c/py_slvs-1.0.1-cp38-cp38-macosx_10_9_x86_64.whl";
        sha256 = "4f77ffe1ecc85507b10ea70276d8b671702b6fc8a0d037822f5416d91920c8bb";
      };
      "3.7" = {
        url = "https://files.pythonhosted.org/packages/09/65/72cdf02f887fe5e3c00274a7daf6a7784e15f2202757e80d0309b7ceb44c/py_slvs-1.0.1-cp37-cp37m-macosx_10_9_x86_64.whl";
        sha256 = "c10992b6a314f7066c7f2957ac18ddf59a94d1d33594f4cdca719fc980dfefa5";
      };
      "3.6" = {
        url = "https://files.pythonhosted.org/packages/03/cf/cc7abf542b2c18fddf2d1ca0b3d9cdfacd919c9c3e6fec1cbd27fecad43c/py_slvs-1.0.1-cp36-cp36m-macosx_10_9_x86_64.whl";
        sha256 = "458c7ffc8ea7a89feaa5fb7554a31e3a2eba189d27bf7be823a2c1fcbf9e3010";
      };
    };
    i686-linux = {
      "3.9" = {
        url = "https://files.pythonhosted.org/packages/5d/61/b96981274d3b23b6f0252e8f446dfbb9e41f12df8a240945b19368bf8daf/py_slvs-1.0.1-cp39-cp39-manylinux1_i686.whl";
        sha256 = "de358a28f02555433b0e75096024c537471018894eae88966be83cef8598d058";
      };
      "3.8" = {
        url = "https://files.pythonhosted.org/packages/3d/a7/fdbc0f88f174f557e4277646026d262038442e2b95ccc42df30593d88999/py_slvs-1.0.1-cp38-cp38-manylinux1_i686.whl";
        sha256 = "11e83a393ec09caa7a5881e97748b1a1f4947d2b286f461126ec4f96e6ca0289";
      };
      "3.7" = {
        url = "https://files.pythonhosted.org/packages/1b/f9/d085b2fec9357f096c25c1e5d3107e3f4201f3dd722b0e112bd86530a6a7/py_slvs-1.0.1-cp37-cp37m-manylinux1_i686.whl";
        sha256 = "f8e7a089fbb1172c3e6edcf35470007176dfa480df8e1e1fd43ccdd627831f4c";
      };
      "3.6" = {
        url = "https://files.pythonhosted.org/packages/3d/d8/ff27bf105854823aa0e30e9f5c8d73f04e27aa0791a474c9de947a1cd3da/py_slvs-1.0.1-cp36-cp36m-manylinux1_i686.whl";
        sha256 = "842ab5adb264d3a003bfad8dd33a062aad361437477fe6650703320737670fe3";
      };
      "3.5" = {
        url = "https://files.pythonhosted.org/packages/56/b9/3c35a0383538d14203b7ecc3829742acb8836600e3c095aabc2031fe6c1c/py_slvs-1.0.1-cp35-cp35m-manylinux1_i686.whl";
        sha256 = "500c8609ebfa0a5cb1717a1efa55ed7b896bb020941dd87b479bd08453559398";
      };
      "2.7" = {
        url = "https://files.pythonhosted.org/packages/05/5f/28a1622d8186a6eb57233bd57e9828b431fb842f2fb5c1b4c2b1a90bed5b/py_slvs-1.0.1-cp27-cp27mu-manylinux1_i686.whl";
        sha256 = "5546ea770060724a848299fb278f72180f5019393398a87e070337a582b97d7a";
      };
    };
    x86_64-linux = {
      "3.9" = {
        url = "https://files.pythonhosted.org/packages/e4/ac/03715ae601aac9ba5319764f04d52df9eb8e2c14fab5825ba34827661a5c/py_slvs-1.0.1-cp39-cp39-manylinux1_x86_64.whl";
        sha256 = "c03bbf40e492e2942148112bc5d0d20fe8e45dee72edb42d6b437907b1ec5637";
      };
      "3.8" = {
        url = "https://files.pythonhosted.org/packages/92/79/a9aab4d075327ecf93a680bf7bbbeed42ffd7929f720171242e69fd59cd5/py_slvs-1.0.1-cp38-cp38-manylinux1_x86_64.whl";
        sha256 = "09d00ef32e0ae32aecfc2471ed0fe5e090777467d8d40516bf8d306213c560b8";
      };
      "3.7" = {
        url = "https://files.pythonhosted.org/packages/0c/c6/f43da98c2286698b9fd0dae3d64c91fdcab8daa77eebc569ef41f56861f2/py_slvs-1.0.1-cp37-cp37m-manylinux1_x86_64.whl";
        sha256 = "5e51c02d45347d7fa48dd199e7aec3108eee6f3bcb0b80b9e5d0b96f8b4da9d8";
      };
      "3.6" = {
        url = "https://files.pythonhosted.org/packages/83/d2/f152245325627cd6aa3bb659475bb962324c2802ef93018271bfb2dac375/py_slvs-1.0.1-cp36-cp36m-manylinux1_x86_64.whl";
        sha256 = "9b77d3cd17370e7a193b19308240d82990f1a8f1871e769bb91b832023287989";
      };
      "3.5" = {
        url = "https://files.pythonhosted.org/packages/e3/76/00853f0c54b6bc92c0e9ae239d21f18d20a96b2353400f58df901e630f5a/py_slvs-1.0.1-cp35-cp35m-manylinux1_x86_64.whl";
        sha256 = "83df8e86ffcccccce1ab61bce70360d3178b039c14ba182069128d4793d00221";
      };
      "2.7" = {
        url = "https://files.pythonhosted.org/packages/4a/0d/47e630a8f3c01956aedf083705b11d709fb943e8471607d0dcd56c0642f5/py_slvs-1.0.1-cp27-cp27m-manylinux1_x86_64.whl";
        sha256 = "c2ec1491825a8b005d8ec8d276b9069aa8a7d82f0ea41e819e15e49e44a8bf51";
      };
    };
  };

in buildPythonPackage rec {
  pname = "py-slvs";
  version = "1.0.1";
  format = "wheel";

  src = fetchurl (lib.attrByPath [ stdenv.system (lib.versions.majorMinor python.version) ] null urls);

  meta = with lib; {
    homepage = "https://github.com/realthunder/slvs_py";
    description = "Python Binding of SOLVESPACE Constraint Solver";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jvanbruegge ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
