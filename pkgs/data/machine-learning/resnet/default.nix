{ stdenvNoCC, fetchurl }:
let
  srcs = {
    resnet50 = fetchurl {
      url = "http://download.tensorflow.org/models/resnet_v1_50_2016_08_28.tar.gz";
      sha256 = "0wqw22aj5pbrhhbb13nh8r26zkj3dkq1ajrhvx4gczly50jxr84i";
    };
    resnet101 = fetchurl {
      url = "http://download.tensorflow.org/models/resnet_v1_101_2016_08_28.tar.gz";
      sha256 = "068sl5x9z05j1wagfjwz3yrxnk1r8ikb8wrx931ckrsnbv7kz0ax";
    };
    resnet152 = fetchurl {
      url = "http://download.tensorflow.org/models/resnet_v1_152_2016_08_28.tar.gz";
      sha256 = "078qf8ajbs7y632fj6jlkfgqjbb53958f3nrnq6rqva8vad596y8";
    };
  };
in
  stdenvNoCC.mkDerivation rec {
    pname = "resnet";
    version = "2016-08-28";
    buildCommand = ''
      mkdir -p $out
      ln -s "${srcs.resnet50}" "$out/${srcs.resnet50.name}"
      ln -s "${srcs.resnet101}" "$out/${srcs.resnet101.name}"
      ln -s "${srcs.resnet152}" "$out/${srcs.resnet152.name}"
    '';
    meta = with stdenvNoCC.lib; {
      description = "Pretrained weights for ResNet";
      longDescription = ''
        Deep residual networks, or ResNets for short, provided the breakthrough idea of identity mappings in order to enable training of very deep convolutional neural networks on ImageNet. See: Deep Residual Learning for Image Recognition by Kaiming He, Xiangyu Zhang, Shaoqing Ren, and Jian Sun, Dec 2015.
      '';
      homepage = "https://github.com/tensorflow/models";
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = with maintainers; [ tbenst ];
    };
  }
