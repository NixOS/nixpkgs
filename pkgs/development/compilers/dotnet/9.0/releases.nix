{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.18";
      hash = "sha512-/WWd1qSkmnVfPM8bdBLVWQdGCVrQBtH8XYodhbeWrFZHfn3Rdf5D5ZDZXp7mZKh1eGBm4y8ZamOF+clQxkJQNQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.18";
      hash = "sha512-OVjEABRMlpYWYsnjZnl1v2V+qe4dh8pANg3yJzWrLYL3lsPAja8T5/KZ3Iv+Mk6cHxUItYd/ZSiCkZBSW2X8tg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.18";
      hash = "sha512-yuXsXQO/15gtlUWYy/NToZgXCESBJoFaEhf64a2FmZeMAh1s9ApQN8EiXCXKX4uPNfzJ25gDaIQ+d7inZWSuAQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.18";
      hash = "sha512-UxVn1KEi8xgxSUpKFrLijR8haCLTkxEGavphZ8vyMRTo/z/vcRfbrRd4l13S0ijVEZKpAFg5+ix90fKdmNkQew==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.18";
      hash = "sha512-vGh/bA/cj8CxyfZJKjRe6aixbUfWa0HBy4LSpNBUnxAsKXcfjUh97lpipX/b4+E1Uy71OUTF4xT7j1QGF3uTQw==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.18";
        hash = "sha512-U/yqbo0qUl3Qhqs/EzI1QlMKIYePCYpKLhAOXB2kk33CrPiqNxCE9mmD4muMbXbTdTOUshh3VXOSUARHU4wLeA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.18";
        hash = "sha512-NoQjyiu/fxfwECe3AvXQfSHPI1DmahNnQ/mcEr9TlDfeb13GzfVh6+pLEHXgD5iWJw7pac6rlEL694DJZq3jlQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.18";
        hash = "sha512-3Xs9z9YbsQX45FZWcmlmvYXicA1fGK+n18nvVvRDPsYEAr7TFBIpXSmBHUBoVbRVBodflz5/jznsF92kv7t46A==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.18";
        hash = "sha512-rK2/A4bphL6LXl/6nhsVQKs0qH8mn4CvdaY9DZAcvP+NU6cqcXx3cya+DmDqwFSYQHcaobqS5wdqQt7mqY5iWw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.18";
        hash = "sha512-C+QztmpRlb0FMZEjkKacG7XG7exk+48ix10EGkBaL1gc3Wz6DN9Tq/Hz0FqAKYsizIuFP0fruroBCeTQ3uyiVg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.18";
        hash = "sha512-xBx0q5hkw2LWTxNbi4Az6Gl4vYYracmHIggA+xmcKENtOFgbhgAQzIVbpl+3fY1ea8An8Pgps8lbZRnLr/YEwA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.18";
        hash = "sha512-vvce+RSEb0am3A5+VJ/AQJjrkeBWuxX4F36ez/8umdMkfYzSIlfbDpI8eLvcJ2VROceGqNK7Do8z+gMuR3XNkw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.18";
        hash = "sha512-4ff0f/wdAI4v9IukzVACxjbHJcNeuZrk4/QpsQWPqIv5BOZ8riMmZtfpWL+aafS4/1xteCdFyN7Yor8ldz1USg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.18";
        hash = "sha512-ySJKeSuSpnDq8AWCet4r/yQDeQX69sYGvNzorl6VGOTWS1w1Tn6MqOdG2lguJ3y1DRiIWuCmHdG/u9pd2UC55g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.18";
        hash = "sha512-mU8u8IzHQ4kA5CCAeyT5bxCLhFHeakRYWhrF3M8SajuqN6bcJx0rEazfn8GZveLD/2M9bhluHqN1MqGFBF8UYA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.18";
        hash = "sha512-mc2gdXJ9UI/8ogFVEFrQCJjM+UjCvs/9eKS0UPol9HtDC/jBFk5srFnYh/VjxLx5h6LusQ/hqm46rd5HXUasVw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.18";
        hash = "sha512-q1CleZJvR0hl/mp3MkHMxcTJn2frQVgsiTyGOquKFqB5kvEzvQsrM4UlP6OqLf5m3JZTzsg+YXatEMgHqPVSkg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.18";
        hash = "sha512-OI1cIweVR6vBRo8zoltpfgHkSx7XRyUVkTdIP/hk2Pd+2j/+1ReqCEnT68/7b8sG28Sl/8eFut8y1ekHBeTSQQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.18";
        hash = "sha512-BOOq9ybpYgEmvDqj/Mh6eU8QuQ+zTgtQFkO1EYqfVyFUK8pbUU/lhyHsydet7UJbp44tAhoJKiauMicSDZcW5A==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.18";
        hash = "sha512-X9c6Rmg1hJD2KjU0pT8/3by3HBPcw3IOyeXvDocSIuhn84wGdpRkiPXABI42ANht4Yj/qV6GZ7khCV74w5Yyhg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.18";
        hash = "sha512-swKmLE3IwI3QBBOIvf7abvs1k+eIQSC3ePg7cmILj5jWO19x5+Xg4Y7qYFb6/QFLe3GPnA8xXuOhNKlzAvJ9PQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.18";
        hash = "sha512-u2yDQloUVUgmYqQfODp84PwGCL4GqnU05zrCdpjO7En47hl15wEnPwODpN7XWYsH64ivGMwLC4oIXUpqJIwqSA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.18";
        hash = "sha512-ikzKJIKsRMGZCjmEXp9rLXkv1D0nD5+sPnFy+g2uMDstvOfVHQxYJAtnhHbyuiHsX9seONOLPF24s+it7rc2SA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.18";
        hash = "sha512-+MT1q6yOr/BSz2NjbreMqDdBMbdqy4mPmbuLllZef22wtOX76o0llcJN6SRMBpT/O4NQJGlX1XWTBlTTKymoaQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.18";
        hash = "sha512-bByDR2I9QXB/gGhIIc0kCOYV7lyPX1b8Vfx9A5GmdECeou/CTgGyHyMrmeHzKNMjdChFL18Xpo8iyJDHP4z5/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.18";
        hash = "sha512-kUy0sDIvFjhyxUgTdwCgGX3jEm2xGgmY+3vJQCsEksowMBVnmL7tcmWZx6LHNICKFdGoKcnvMCJckJRJwn5rIA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.18";
        hash = "sha512-ee+X93XyxderBrtQWsZDN1q0b1e47+QTjoJWSXFTEDv034lJ6vmfRfiO/qVRtKtEpn08wsunSNYopRfR3FmLAA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.18";
        hash = "sha512-ioABVap1JPGSUB9tY/EvY4wqi2Mucl9HX0+a82AgUAukjBp2kFEHDtgXdrvPJ/Xeeiv0zRXqjoFzj7ph722y5g==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.18";
        hash = "sha512-3j9w6ITFH63hlbrhER1B6hCxY11wFoE8FCDFltPUUMsXs8ftE4GTJUa2Zh1WXEAHllDMZoMwsbTAGCckRwIZRQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.18";
        hash = "sha512-uuQrHRhQmI2Tln3gzuwBb8oki7fggOEMVxhULIjNjkWOg34P1oHrh019rz4CalDR8WvCzHDrHz7W7RlJs0PbEQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.18";
        hash = "sha512-l765I3RFBBqY4raH9NhrrsUnPvqR2nphHm7Hzdl9cNPe2iv7nIWkeRBvc9xEr+4AFcmlzGl3VLgZpctR/CYECA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.18";
        hash = "sha512-OH8aG//KzX8bOjhkApSq83SAUsJi6lz1MM6eFymA5oX01eNePGCuRRHOWeK1ZC+zeFxVbae2EStad0XUpFJhSA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.18";
        hash = "sha512-8w1M5ugcGFU5ktkzALvvhGwxeYicf0R3csoxvpW2IiIhWDEILGfcovNWqmIVQcBLLtWDTo84baPFiWziqZ/4Nw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.18";
        hash = "sha512-0SdRhX7UBSXARKlKysHFjvTT91PFZyFn/2aEYW8fwIAVWpfvBsgI9BQ0GMiwyFVi9yknFYOk8jYhF990YIC7Sg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.18";
        hash = "sha512-79wzG/nHH7yLJUVf0jYTeNY1s+jWLF8RZQhacaWAk3FHLw1Bb1IRkPDcEdKPWAdFQlfZpuokcCBQf4cGCRQ/IA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.18";
        hash = "sha512-sxIdoftl5HQKQt0porP0/8H8s4w27Y03m48ttrMiEzb1C90eTO/K2tRVFssuXsw2A9HZcQJ5bgv9U9F06BTTBg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.18";
        hash = "sha512-0B5KLiD0T2Wr1PllbvOU/ZxoJlWLOSr2ug20uPI+hlqSue3o/4aXyw78RIYftT0Os3w4bAXWuAisdULucyZAng==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.18";
        hash = "sha512-se/HeRvz/uxe4yGuliYsz5PAETdXXlCSALQr06K39UJa1cyL/9WN1am4045ZP8NULp0MwCtO5NqIVuvCteIVqA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.18";
        hash = "sha512-moQQpFGgHIWYvOPtNWmPOgWTxQGuIKtA1XZe+/qPl05YLpLM1DhpzVvSDEeDzNGxmqKLo+PW6en8Q24e38TvTw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.18";
        hash = "sha512-kbB9CVC8jKQTJqHmw2EscXVv0UiIht68hXDLK2G+DKEfNdyarXn9lT4ZGi7NCAYeXeCfubfd8OCxTDI4wOKI4A==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.18";
        hash = "sha512-FwEq2KOyY/s65KP6stQBCGj3/4P6GF/4bVqBDjxKlP25v4bGC7I1Clg+Q+Vti5AwVMvh6DYOf4yT2RB0zuLKtA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.18";
        hash = "sha512-c25do9ipY4Y4WYF/3L2Bhz5A6hM1qdfKAWmYOmuG4u29QuBlK7ICW4RtwFIDhPuXe9i0zXgPQ0nOZ/wR+hruFw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.18";
        hash = "sha512-dj4UQ/iAkh8ogNbO/4/Kpjy/CaOOIiRto37vYGBaS7m4NKK/ggj4XgljrTm/eQkbj9IlYqySr7NAlwx9lUy5iA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.18";
        hash = "sha512-XxfwcNnN04ZKzafril1hVfD8r5+tnTz9+dx3tP+RuciCnYIpstDVbWrW5Xoluz+3Ah/wuGWbUHlEIR79koBz0w==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.18";
        hash = "sha512-2sRI+k15detMJP/dqo01TYAGq9J/7jGDy1Nt/8sTtF2wZHw9VMlysOLe6LRrvjnzXOWpILmHRXkHvA28wrqaTA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.18";
        hash = "sha512-B8Q9jf5cNN0v09yUioo0+ytdffmAyx1auncwKj1r8ZP1WT7KkurAyW1DgBIrklBRLOEK3BWG/ycv8aCQZvneKQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.18";
        hash = "sha512-Hbd5hE3o90QdwTiVJkRzc1YEc/l33Dbez8w8dUaKyNIyi6BjhNSeXEMlLSBBC2Frg/cZ6Xdv+wL9Tze9pMLgAA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.18";
        hash = "sha512-tDQjtr8EE4nkoY/5ogQeRZQuH2lRNwzr7TdKrk3DnKpQo1kaUj752oddASdmsV6AsYVSzJl9zIoyHgq0ROjhcQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.18";
        hash = "sha512-ALNvbnl/W/SvHfJC3atUGe5Pc6FxlIJGa2zp7Ay5u4njtfBPu6wKp7pOq6g+pd1kWLd3QlKZ/KbAgUt5BFFL+w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.18";
        hash = "sha512-Beu/cAU81kVan1LhlJXON8S+dtMrTHkUqWkJolDQS9k7ynkZkfWaduS66J4IBaVVuLY1UZdJ3gbc7ro6IgSmTA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.18";
        hash = "sha512-regM2Oa4eLL6lFTXv+ABf01F6ClQKqcbH77+I1Ll3AHDM51P0iELKDDP5TCZA8nnk7VEY43k2U5EYmx0UJe1YQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.18";
        hash = "sha512-RRgkiiaRSChCmxYHgYf6GwsgmCfSWme7SF33eCBHPQ6FJvOmXhAN7mUfrbHrrtQy80x/YOcnZF1wPbk028I6fQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.18";
        hash = "sha512-/xGK2d4NpSGTK7Z1K5CvvmGIG7THye6xTV1FKV7xn+SNk7lXoUA6SVyKfucc5gkp2UrwHzbNz7E7WSGqxnSjOg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.18";
        hash = "sha512-a2nEBhf8aH4esKSSdiYk0gT1xFwMcy40azw5tB4G47iM4ZgZcdLL6uSZ+NvQoRX5wdHxRbzYginfVxAK6d/Bug==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.18";
        hash = "sha512-WcDLnAa6lXW+yu66gXTjEJ0dDThZ3wcn/uyT4tnjc2xe4KAEaYwVW0yxBcdGJ4TqQHcM+NYXfrTg8+H5CiFxRA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.18";
        hash = "sha512-yN8fgj6iTP/bY8f1z+qran2lYTM+xvSykUydP85eeBNjM2nRud+JgpvfKQNF50aVkXKsXFyDw96UtaMYrE2WJg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.18";
        hash = "sha512-0i3fb2NcAwqmh/e+NZcRbXckCY2fDfeBk2vLlrLgsgkTKucNCA0dZzDLeKIaPiPV6ABfLWE1pPXDYPYRJKr+6g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.18";
        hash = "sha512-WnEKfmxhFlui7P8Jm/ADhOaZoxMMF1KPIV30Zr84eKY1EsOKCJbd1m4zUaUyrSzidhwDhW2D12mZDJq8oC291Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.18";
        hash = "sha512-eSnGCMzBBkZZG0kOh+og8Yrql/SWKhm0mt9GyOv+acvs6ZUG09XgHnpRqe7+aZez3tWx2spcXfnInEJc2S8uLg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.18";
        hash = "sha512-cNTfKWWpmhBckC08Gzh/ji6mdDaQzRZFMNutF6C+ie0mVz4HKcubGuGZ2ssycLYuDoAAxpjRvn9RMVWgcPFCxw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.18";
        hash = "sha512-XIMkDAWfeJsQIBtt13V506pgRTk5Qfun0tOlKwwiEYKmjvOYoNbAqqZfqeQqBM37pv7VLR3sLrprmw72+IGsQA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.18";
        hash = "sha512-Pqibz06N/oqXYXSeypG4Zn46FNxsVhBD29pjKk8hgsas7Esbk8lPSxp9qs32+IIVS82QtDc3FSOcJVah3++ehw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.18";
        hash = "sha512-x8U0pDajcJmcPSh6bvhQmr701pk98W/XtITxa7vdpcIqxNE14wJ9o6fmrkyD/Jks96MED/MOuaCNQEhN46orVg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.18";
        hash = "sha512-6GHKLICs2ADGQ224L3MysU3k5UdFlrFRf6Qs6W/rMkjC2otg+DpUp69J/Y2gOOGS7DozfDpj3HmCNUGe0FFuVA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.18";
        hash = "sha512-MNW21+AoIwVYUXKlXgC8xKxocqB02LbWES5EmslBHXe+DnTaGkMKiOfWsQVfLdukzReM+sl1REJBEAY6wik3uw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.18";
        hash = "sha512-D/L+J44va6/lj4qhKv32FTLU4SPoM5xVSdp+775N+lKknGj/VgJok1XpwJscn+zwT1Y3tJUfXOt7Karo9nZ/5g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.18";
        hash = "sha512-POOr+AGAFRejmoFfjjm9JQMyGYlQBxhRJRfu0gXDXWdRUy0pOgOgsoDHuWQqKAGUGlXwJwrsiHT5tgDPicCTwQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.18";
        hash = "sha512-++4x5UHtecgGyIcFfL1ozAyllSv9dBx4pAjsr3oYNT/wK0idP0PU8rJ2x9GOtOX40/W/Tzp24wWWBrbDaIeWrw==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.18";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.18";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.18/aspnetcore-runtime-9.0.18-linux-arm.tar.gz";
        hash = "sha512-EpB5MLz+B6jBBKv6eznK5VlxQNQjJEnmpFLGLpKtCK3jgD8frLcK/YoIoxMglApW0kNubbTf8llAlM69zjhFsA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.18/aspnetcore-runtime-9.0.18-linux-arm64.tar.gz";
        hash = "sha512-B1wjLkzIY0hpk2jc+JpoxaOpOGdqOtz3C37SKufkpbVDoj7+SXkKAL+oHKjQeVwrVhBEtipiq+Z8edSFo1mwmA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.18/aspnetcore-runtime-9.0.18-linux-x64.tar.gz";
        hash = "sha512-Qi7Ntw4kVVqppYfYBI0IfeKk3glmrXPH6qPbi1IfJvPjnRK/YQYXaRXGuBLZNkEbOnh57pKKfDRUT84IMOrS1A==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.18/aspnetcore-runtime-9.0.18-linux-musl-arm.tar.gz";
        hash = "sha512-9AAObj/H3+VM74YtPqoYPiAFjtfOU1qKEqLWonBzabR6vJ6JPYIqt46iCdWzIprOSGeaiEQqKskDy64ZML4o/g==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.18/aspnetcore-runtime-9.0.18-linux-musl-arm64.tar.gz";
        hash = "sha512-0fCooEuSxncKbjN3ExgOH46xVk4XM0wmAl/hOg0/jVumjhE6RVTJbv9Vdx9pqJ3IRWHhPRLRfo6nb/I3QZ054g==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.18/aspnetcore-runtime-9.0.18-linux-musl-x64.tar.gz";
        hash = "sha512-XbXyTw/Rk8qwsXDbw3XjyrLVGQKj3DXi++G1CcEPaRP5qU96/xZuLLi1m+ZelKziNAdr2t8N6vMIZOp9FvJmWQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.18/aspnetcore-runtime-9.0.18-osx-arm64.tar.gz";
        hash = "sha512-NDq1E9+CoLEapLmKEUPh0cF46QbYMV5IRxEm7VEa7f60N8sSsHe4/AsyILIs55uaiFBwO1+bX4g9zojmmTU6VQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.18/aspnetcore-runtime-9.0.18-osx-x64.tar.gz";
        hash = "sha512-keWKx3Ct0j1UNHUsBovruP7cu+b7hTe+Ia8Mzol821LSia31yQTnO0HMOeAveRy69wudCcHcRDwVhnr42THaIA==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.18";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.18/dotnet-runtime-9.0.18-linux-arm.tar.gz";
        hash = "sha512-NbOG2rylurWCeqrYm+ytzZ7sPHZv8HIo0B/SYHPFSrtUlxiZVqNqkVC3PiPj/kWPI/v6Vpg7mH98MqrYud47AQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.18/dotnet-runtime-9.0.18-linux-arm64.tar.gz";
        hash = "sha512-5YpVm12r8BJ61SuBoveaCBYsOYSvBOLleFdV3HIrFuJuciSMgnayHczo03AAB7ncYsgjKUeL/nbk6eA88CKWyw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.18/dotnet-runtime-9.0.18-linux-x64.tar.gz";
        hash = "sha512-l+uJpaN4G5dh4qhQmWkSroG5aZYInHirzrvEQRE0VwiL/L188fqX0wNvesj+IsfTDgQ+k+yvyRDwe3MxfHO61Q==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.18/dotnet-runtime-9.0.18-linux-musl-arm.tar.gz";
        hash = "sha512-vX0ihTxrCTKujuTvopOzRQfJIQipm1S3QxAZwK1vGM1rX9HPI7ygZGCTJBtIwef2czmlcyHEPFtNdE/6qnLctw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.18/dotnet-runtime-9.0.18-linux-musl-arm64.tar.gz";
        hash = "sha512-t0Y72M9HjDvhgC/ixKuPkIAkILyWPUMotcc3qn0knlDKoD2ycg/CMV1B8jUOTVtJFIzkMsYFTNe3aA7niADiww==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.18/dotnet-runtime-9.0.18-linux-musl-x64.tar.gz";
        hash = "sha512-ue0EnTJye/9pSCnaAvjDWeTZcLQP67ts7lusnBTOoHFKDlK524OOkpU+jPZybRo4Yfx/s4F75jZPN/h8QU2HuQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.18/dotnet-runtime-9.0.18-osx-arm64.tar.gz";
        hash = "sha512-2dleEhQjILJbt467IdOXgHt+BUrE8Ull89cEpY/YmehfJsIfRrHuy+lHwukleti9fdVAm+9K1/UejdtFFoQHpg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.18/dotnet-runtime-9.0.18-osx-x64.tar.gz";
        hash = "sha512-+QhvcBgP9+YzfCTwv1CT5d+2as9p09jhvZ1bbmTYDIZpaYanPF8SXuNxpz6vvhLCHTNkG9H2JM63/2f4I7Jk3A==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.316";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.316/dotnet-sdk-9.0.316-linux-arm.tar.gz";
        hash = "sha512-yGqwPSrN9JvXAcHAIaMTLhbJy+cu1F6E5ipEDSwFPzS9dtZF3O4xS/PoEpoorlu6WEdPwnipQOt3aapD/7LSKg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.316/dotnet-sdk-9.0.316-linux-arm64.tar.gz";
        hash = "sha512-QIMk/U7oKMr6F5JuM8EsxIRgaZtYqDIsihiR74Ht3sDHLfEvp6+ob14i+ia8N1DA+2BIG9Fn5LgI1c+5Ud8GOA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.316/dotnet-sdk-9.0.316-linux-x64.tar.gz";
        hash = "sha512-WoVYr9ZIwUqDXgCuCPpVYIP1DjraFk0+cyk/zUhQsFGaJ8EfLa6Vqbvkr0Mr4zvxRFHvEbppUn40+c8wd6HCtQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.316/dotnet-sdk-9.0.316-linux-musl-arm.tar.gz";
        hash = "sha512-44GuDpkGMs9X47tljgspYY+RzpYiAhBlyUdqJ66YKS2EbiUn7RCLvv367mgLgtVPPKbdOvlNTGHsMQr5SP29Sw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.316/dotnet-sdk-9.0.316-linux-musl-arm64.tar.gz";
        hash = "sha512-xBsPEE2FKInO1D6DpTx+4uZGZrn9ylI9p6XDOwcn/+m83W5d3Yoqf7f+aCmTGDVK3t3GG2PMrLjlzVPjaI/yiw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.316/dotnet-sdk-9.0.316-linux-musl-x64.tar.gz";
        hash = "sha512-TjMynmU9STLEY2IIMzH9fLXMni75ZIW4h1OjKo7mcnhqnRQ/feHsBBiPwaR0Z3U+E9LSc0qcdgJx1CaDTrj3Nw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.316/dotnet-sdk-9.0.316-osx-arm64.tar.gz";
        hash = "sha512-vEZFvKTSY6H9CISKEXjCyHilezlMVAtel9rjpEP13siJPQnMGUsNCtrH6bnXsYNBp2UUEZmc4S75CDypk2wW8w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.316/dotnet-sdk-9.0.316-osx-x64.tar.gz";
        hash = "sha512-xGxoUWOFb1u3KMXVjleI81TLBuIJTYk5Ayku2YXRFYb/Uei5fDgWm5u4IwHDKkMklUbiPOntQlnRgCuomJM8cg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.119";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.119/dotnet-sdk-9.0.119-linux-arm.tar.gz";
        hash = "sha512-W8XwMMHOrORZljL4ZSYfdoUNZF9qBEXtXvJncLH+4SLcJGlWELvsx4NU/kAolSZVjeFi5PzQXLB18Lkq8aA7ng==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.119/dotnet-sdk-9.0.119-linux-arm64.tar.gz";
        hash = "sha512-o4wcPwLHLKWAdNhHOlcu+YwiLdz5euxeC/VG91eMCcocS2hSNGIVHZpYpM89WEMJptr8jQz5+k9zT2W8kQ5Urg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.119/dotnet-sdk-9.0.119-linux-x64.tar.gz";
        hash = "sha512-J3GDQXjUxcpfEebCrqwT1rD2+V3G0RaFCSmKS+ODdniFNfdPlnXes0cXSdS3YIp+mOdffA8gWurvCuqh+XtyIg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.119/dotnet-sdk-9.0.119-linux-musl-arm.tar.gz";
        hash = "sha512-GoSLrCjKvbDd4T+Iyv78ch3gVVNNkDAkQUfwX1j4PSSWZ/WXtj0o41Gk4UbmN4FukWcclh9zj2BSYBoMtj4s5w==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.119/dotnet-sdk-9.0.119-linux-musl-arm64.tar.gz";
        hash = "sha512-FDPQSBTGsgjVB/JTmL3ZHmPsxig960W/6f11rij7KdtAHE2yd+SbXhIOS6lj5q4R2zsBaFZr5Z7yUcdfPlpoaA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.119/dotnet-sdk-9.0.119-linux-musl-x64.tar.gz";
        hash = "sha512-fDiLgQrIVMOu9+DNOvZjr3tlFfpqjLR4txh5/L1IvG0F07fA0nLCht/6QfQRJGtuKVrok6yzuwgZ71rtm+np2w==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.119/dotnet-sdk-9.0.119-osx-arm64.tar.gz";
        hash = "sha512-8ArSNJ1r08gGp5+MzFdToorrwqfJpgu4fNmGha+OTe6PPpX9GpNb8uSuiCmPYk9kTB1IZjZluIYfZMBLvaG1fQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.119/dotnet-sdk-9.0.119-osx-x64.tar.gz";
        hash = "sha512-H6tule2exeouYc/W47z8lcghqAHkjxJzz2lVQfnaWnmugvdj0w/sdd8+Cq5RHpT8dFjMWJ5a9oDjTvaLirrMtA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}
