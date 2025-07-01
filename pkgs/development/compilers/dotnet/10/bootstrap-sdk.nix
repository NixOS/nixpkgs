{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (preview)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.0-preview.5.25277.114";
      hash = "sha512-s4HlvPy1QuJKFkv5YvtRhYyOBiOm+OHD1RDnOdQCrpxCVbBEguF5jv4Ad4GX/cEqW+HB8hSt0Z0b8+rHu5Ki+A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.0-preview.5.25277.114";
      hash = "sha512-CpTBajurwDJBqGksHOWwf/deFNhBj5mooR8mkK1hpKexMR20KuprblkuCxHEzdf99F4pvOY3cpi1jpE+jkhqGg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.0-preview.5.25277.114";
      hash = "sha512-MYy3h/RxwEKD5fKfyW8xb+qiYAdvXmIh4HCxXpiCII04SvWH6myXrF+IsdoAdtIFdNnf/MWe6zbaUi1lwh5MEA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.0-preview.5.25277.114";
      hash = "sha512-IveQf1NcMPHPWL4JWlmhjE3Zuh6Z4EH+1vJGbT+WP1TwxGLiek/ejwS1PovGP8rYfkOEWT9LRAE+cHjT849mTA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.0-preview.5.25277.114";
      hash = "sha512-/R/whqQSpMH1QImsjt7uq2ALWe9foCob6gVheTqF+Fnwu0LmFZbcAmiB+oEyCt8hJwmS7i/YVg8Gwod5VzdPIA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-5ESzKgrodn+sAQSmMLOxeS7mJWm8BA363aPG91+k/35/Ah/txahPPCc4omRWDMmEutK7fCY8c7zgS7tGlf7McA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-qEaKvjfg4dv1xhz/y60Y1n9dQNM5TLo+S5ncuwnZTrUVAxlXBtq9IYqZJ3phynbt5zKPgyqk3P4AUQ9yq+Os4w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-FuN+WXR/OVGTxucPJranVRmxbYdZgGLorua2fl1H8tDXrgnFJ1r1gmUS5nDVG4+6zlbAohUtCmg+CLl2cJZshA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-zFwwL03ZGoCFoSBMIm5JxwDqHoEFwqWQY/70z8L708keOulasLQaZzNo+0Aj17LRbO9ai1f0NraNwgkQipBw3A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-Z3yH1oMeEi7bfULV1vsJUmhJV7sGFe3j4sTdcQ2Iqot2KnNq54uUDkHigPRSi0PQ0p2tOnK4idVTDntITm4DWw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-50+U03mBEDtKgzzQus6e/b9SPeY5hSTrm4k8Jk0AyiKzU30UL7sjgQzfRGGvNEKEEScDg86nqeJ4Ox3A8Splqg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-FOGUGW5RSoxkBLjiVP2Rq6yIrODbDFF822fAySFR0Sb7Wl5zFa2DBrzobjjpPX5kxGO5g/KDpvvhzc5ER6NSVA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-B/YcJ/Owoamyww7r2MsTI2cSWTmADFiUAH+JLXo2gJKx29W1FHo9/AJkzhj4hPbTOjcxXZXgnpdAv1wpVAsgRw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-EWGjha2ABrQ5dc80NPXI3wqMBwTbV57Yd8+vhtG9+TUkdaPIm7Ih9tiEskTdw4bbvRi4WJaPMlkaw7t1bUcO4g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-4KsNQ8Qd5WwJGSeRM8oIUUc0xlFJ4Sijfmyi+jCHGPKs8NsBOeojdSyg36ROBeDZ1pJVkplLqQJkl4/QMk+6Ag==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-t2fI/fmsogh6D2d0Y8QDBvvubtSNxfCuwoY0zHO2Kq80VflvC9AnC8JGEBjiGH7UDf57sVDzZkBkFcB6zIYEpw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-A8r/O6ncUS0OoLWuIO081xE77Im/EKQ3ath4DzqL27GBO7AqBYME8c0fEMxBn3ezqDKKgp7WoRjxmvyFrjjFUg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-4XoD65xIjjxalBaqZp+wGp2IGgbo3MVSs0cPV3LRuyuyci3TEZmyYj63ZbA7zJcjzXJXDhgjQVX14JPx195ZCw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-TP1b+02yPlLhvj16Hq2Fwn8Qxq+NXvLM0QxxIiFCa8RHijb9WmSRvzNwUp1HLxjArzgbvCDlTmwlMsh2LbwSvg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-DoHyLSBIYsD1mfbHnJDKi7PvqPOSd5ySoDeI2m0pv55Dx46CQdks14lIuusttk46bvBUFfp63KILpbmQzU1ovQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-Kbdr7rNaKTP8XaMzevtG7RPH+UQ4IQQd6No7fzBN7/VStj1uPc4Y7OMxrDtnGZFbGo06IbTtPSAxcrWj6BE4hg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-3ShS2dKWGFmMgI76TuN1kYWzDpumT9ToxNVxMJTt7I6t+vICEVbwWXZPi2cD7ZWHrzi3/tIgSVzzHNFazj13oQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-1U//TasFxoxn0VJjA/iPzzJDnQenarO74bvPMraRrQfGqR4t2AEZA1gLgV5Mz38LVB0irpvxdSPoEW4keNA0tw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-KIydC5/Xl87tFKN6pESgrcGatj0zcf1bzgBjlx+qGr3vk90EHRV2yk67hLok5jzqlnbSBKrF7UwEau5Se0mMMQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-sZMp5qkPDTK6VyqYT4a8sfGuFb5xkUo3aIaXDRjOAQznRmknxKycMQxV0pIxxFvVeyyBeqvxYslT2AhhL+EHAA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-6Fblda7ZmvctHnrFBgbPI7ASkzBwA6PyENq/fBAKN9qXA1s3RcITpRE05IIiXWyWetC1069bbkZZ9IJ7fJGQpg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-/NjUBaHpFjAiugmZ9mX5R/v5nfey41rWao/msHOt8/0nafBqGiOxAL31bTZbcgMIIt62lOKKxjWpJ1FBbSiM9w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-R8veKCL6tx0+Mf0dnLS1S0vy2VyaAHkOEnLpr0P1lGuafdGUH6U9soRORAmN4Yd1Li4M0o9CP11Izunq/iG3Pg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-z4nJcFunBtPJgbSQO+pZHZpYVH/hnDWBJtSf5J7pVCKzRYm3mJb1N0DIx/2wB1HtVg0cvw5K1QIBeQdBv5aRxA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-6HRNrz6RVTrD5XQuq35HhBE5qC3iBts30LwDZ27eICx3xSoe3cVX+cDKyaQenobOwMCS/trHB1AvfkTTMI//gg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-TWpJ6I11YP653VrhYUiSQgI/mwCfk1t4ngl0DBGezsxuSsCW9SrVVsZaCoboAm2hKbGlgC620YQOCLUofZxaRQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-I1h/tB0nh4CzOccmktX4KSZR9dNqYrqS1nZDs1ij889XtoIrYePtSnMasnxMfaeMp8vY7WCSKSWNPlynhOh15A==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-5+DdKKWt/JW373FJ6r5+vrQRhv6xRAyQXPeHdrAEAP/wlK9AnJE9pYuHfQI2Trwqklak5O1Ag5GrRin/7oBVaw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-zbq3UWa9qBoaEgYvvU1dR6V9YPIHs+liWOhUj5qfGBGKtZH8bTvpbNu0isYms0d9ML69aWTAiZg5C9rFP5hrag==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-ksXckpgL0kdZEVVgAmofcEUL8GIxwPOGS2+UVN8Fo7gj+RV0zwbXSUH3v4KNIq/8ngFVOh6pQU22CzCwxoB3Pw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-bpdq72fgG+2FD5BC95wpEikX0hmTnypjS+ORXy9205+a3ElhlQXzwe1u/x3fNzAKOXVeGatHibdzAHrOmowARA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-ctmfELPcwp5Vaoh/3oQVoe2ZtivoZarY+XgVW3jC0hvn7qiensODQJP3am84kRu5l4k/c8MFU4HJkjFEopFKCw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-v39otkbx5A2qerWBnqFu6ZtJYXy4sMvK/xv8RGMOgLR7VdcD5kwQpF80ldz7de23qh66nRFd9ONLKajtJqu58g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-BHr5lNkp8ct/5a2kSVedpsTPKGhOm/ofmD0Tgb7a3vT0dEsuzH+4CwcH7/QmSfyr/TaJeiOzraBxIuQwGlDTHA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-0kygUISqT53WxlL8CYxN7yR/imN0z3fKWgm3NKhUbW/nURkcvLz/J/ft64/ib26Ez4izYNnRqJOYdAaYWSd/XQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-aOBEqQy1MMYXjG2tCc/yvCN+J5wRq0ZONOW8CTDIXJJVC7FDsW4gDHpa8B6j1D+Cfufw8lN9jymwmEkg+bfQeA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-nx+JKXvSyhia1LdIRj0wN/Enu7hEoggBI0/kZtE+K/k5RJAX4An2GVirc5YvuM2FhWnEHC72Ex7Dg74Q4rFWBA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-Ik2gQHaJkzM45PFOzFW5nbTdXJLfEcBtWC077cD6Lzmdg0C+jRRYLpDtXfEqt9CMBdgGKYWR4KBLKubLiC7nsA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-YdnzOIgp1zhd9OUpcEQJ3/Fje9GviYa4/+bbn8StJgMK8RgR+9CTQeC1ePazCqKXQ7oYcXXjgchE8CbNsxRFfw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-39ITIAZNO9ZVKE6UY5KKSWvd3wiT1b6n0nUfApUCqMd5MlkExTuMKToY5J1CwWhDhWTq8d+q9USCO65MsUueIg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-isbzkA/HOGFEqZLugW6V9C7xx1RLA6p5v/YrdW9au1/RaCjS8OAS3/rcZKUT/lu6wubSGHaLdzWeqIwmWwgoaA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-whDhidFeiAPcU/aSCxUcgfgjbISQw2IwR2fHhHB2vE5Yf97XEIzYACpi/skGYqBWroXYAmaU/Pm5oULMrEJrBQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-5N7wlWk5zDCzwqee5s8IDVfBMk7w50K6nuZworGH19K1q/twuuwflRIz07DBvNkhmR3E1ScSUYmZr3YP6o95aw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-R3bUl0oLPwjxngS/KqDYO6+lhhwhAmd5N4yOlOqdpgfm719+1vuCYc2VLOx9MIf+sh664VsfuByCI9H9oji9dg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-Rw2ijbzcMUbs6vGu3AxIGNTNB+ZeZvuNNDvsj5XTOSL1o2ndU2eW343QAi1hcKXL1pc35eYJZWPOq/gQgBSnVg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-npo1EFBfZotj6hbR7uoArZeXEQtnKLarXYnez8JmmAZsRU4osSvYyg4Q/jGopjlFEuyixtWc3rb9rO6njYwxew==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-tWtY3DpiKsyQNOg4NN0i/IpRpJ4vjmbDk7B+OdqQrFKGwR/HKXlJ9KOMrqU9LsvEFE2WAGAr/UH0r96iZFAxtA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-9kI8hH2vS45pgael3UCyVCYvmYH/cXKVrFzh7toKoN1p40YPsTh6qHQRjO4W828zdy2g74T5Ct2ypgMGfdzyyQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-uvB/nzacyGad9m7Td8HxrJvyEB7ZNlpm/cxk/G0ufjzTXofWziHKzC0x/gPdc2tZIJQPOaAXOUAcJo1cl4FUug==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-DVJVHV78Nd30U6kiQon16sCPrXuaZLOgFQMLFcMQ4L07srDd962CfijiWAWY5tvl9oO2uWWY9PVqvMFyyMI/YA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-eFsS+N1nnCG+NGq0jcVhQ0vk3Vthyrz4FsHvZqb2YUwvTDBy8deJZxgaTWBuzRX0QjMgojXjNRCGnjEdtOesEw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-7raTvTDZSJ5SNIPU5hug3kGnQqKpNhaBGrXH3v9a0usFRgBbvXEBS9U475YH0Xr3skdOkGESxV7TAzWqMwGGuw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-4zmNNMtPHXZpvAZSJcf+/gKIJ4bklQbhkwmllkboOyD+LHeHTeloBakB8IfVc1ZIPGeYmoH0rb7WNHuARTeAmQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-7a8P7l3yuhiUZfRCSy2BCLedgSVCIOGktdjIniMlQGou7FON701ld0JNI4Stc/WdOQe92IfOBxA1r2mhhpm+Ow==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-gSMZ9F1gZ/cuDLo+I9k0/9h8Yz0xFRsCapNNzP5J9VQYzbQMU5gFp4zY2X/+ZIUNVQtCrTgDNNy4RXoP1Lo0DA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-EbFp4C0rB5GEd/EXaXTA2LlQ4XwhhzBTIP2f8AQY/26hYOXTYYk+ssz3RGNh81vt3QbBZocwN//Nx+mvwf3+iA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-q+bdIwi2R6egAwfMbBFpjjl2T2ADeMBumODqQQU5kO4p56bSYAN97c2lAnJ6I+8x6EkZ92SHlAVrmauH/XR+KQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-x4c4bS0IRW8ELlG0ND2Wz3zMbqZGDgSV5WAIJpJh97SvHVeCZIZ6FLB1EsYmeMTCp0zyt5ZYOMCTAMuBO7B3Tw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-WtDdm/9kPWVZziKlVSZ95cJYBFZ+O9acpLsnWu+a4C7uaR0PnVA5kdV/KPZpZp5ZuSGDzW7LuZy85e/zYU+q5g==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-XLolCkHXsP9M0HBsRHxzWE7Gvc0PYUlYFOa2zbIM5YqrnS3fBuSkwuy4pGKB3ovNhCV5M6ZUDFkwsW6QFXtdkg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-hOgMOwwqKxKiEh51aoDrXS4ygFfByD8acPxhUPQKbuewoymPzWgF/BppaIyXJVFNvi4YMm0ANaQZ7asRv+6QLQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-UYv0JpAcv6c5c7QdeM8xmQULQNxeIv87OYh7vVmy6mmGLVOipeDynwUrrZreyzr/Wl4i86//JsyEfzEWhViZZw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.5.25277.114";
        hash = "sha512-KdRROs3JSxZ4+Wgqww8EwWE4p/Redg9d47peJ7sjsgAlRqTK8WpPiN50vPu3pXwcuGZozJ5e7dsg1/In1q6lZA==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.0-preview.5";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.0-preview.5.25277.114";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.5.25277.114/aspnetcore-runtime-10.0.0-preview.5.25277.114-linux-arm.tar.gz";
        hash = "sha512-CDAgO72l8b5njlm/COTL9sDaUsmAnQJgBLou8OoP1qMIjI8CXXqSxmGbD7WG4HBW90laJtX9U3yuCatxyoFuHQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.5.25277.114/aspnetcore-runtime-10.0.0-preview.5.25277.114-linux-arm64.tar.gz";
        hash = "sha512-rJnr7E56vWYKJzF9N9pWrh+o6evb9KiP5fm+WOH01+jwW+wy1ekCwP3R6dniUM20lEgmZoIBDkz39GQPlpm58Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.5.25277.114/aspnetcore-runtime-10.0.0-preview.5.25277.114-linux-x64.tar.gz";
        hash = "sha512-bmmoX34YuO67X5mn6Amdsvpdo0vPB4vsuxI8CGPUvntCUsfPxrIblYX0+ADAWKEsrlXvKmO5vqiGyj0dig7BEw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.5.25277.114/aspnetcore-runtime-10.0.0-preview.5.25277.114-linux-musl-arm.tar.gz";
        hash = "sha512-eJ7G3LaAXtcJ8D+s0Z4s8E+uuIQI4kNrx+fnbrZfJzQC9HFM7mDGsI/ZtZE4v/Q7gFll0dXFulhb6uceX/uLTQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.5.25277.114/aspnetcore-runtime-10.0.0-preview.5.25277.114-linux-musl-arm64.tar.gz";
        hash = "sha512-sG1ip8UwDEp/x5VDgYDifBJ+lxV4+Ph0yMbXM74rZF77WbYz2I9mWMo028vItolnXLNlGmElmCBPwqW65B02HQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.5.25277.114/aspnetcore-runtime-10.0.0-preview.5.25277.114-linux-musl-x64.tar.gz";
        hash = "sha512-yZiYPbLNXoujcDkAhzkp2T8P+MalG0ZaJwNZcrp38MGactPLhULdsy/s0edro5cWJzkaLgD1qf4d985kg5LTFw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.5.25277.114/aspnetcore-runtime-10.0.0-preview.5.25277.114-osx-arm64.tar.gz";
        hash = "sha512-YjtaKT+Y3TXTBfMRKBeSoavZzlV/MaZnOUPyC5KObqkYB2rY8hmD7FFIIGv6TAiY7o2SbflJJYOMzhGur2pVJA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.5.25277.114/aspnetcore-runtime-10.0.0-preview.5.25277.114-osx-x64.tar.gz";
        hash = "sha512-IxZn7c9uc0JAwKj0DrtCjntWhcUYW6H6UNX1By7YZTP56UtpVRyL9sFtpN5N/UmA5qwl8QShzBUYp5I5m/ImjQ==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.0-preview.5.25277.114";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.5.25277.114/dotnet-runtime-10.0.0-preview.5.25277.114-linux-arm.tar.gz";
        hash = "sha512-2SlNCqSiJOGnarCGhNgnWAhBtFoNlpU8MX70/ThYwIUkRVswJzT3btfVyUCyEv0Rb3pfExf3pEY6rb7JEJia7g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.5.25277.114/dotnet-runtime-10.0.0-preview.5.25277.114-linux-arm64.tar.gz";
        hash = "sha512-muJNZSjDAkL1N/LT462JuH6+R7rUQf1nMN9SZNE1pjcFchtn9DTiJRgJATslrbLjc01lDiM+bIccV51xMkCmUA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.5.25277.114/dotnet-runtime-10.0.0-preview.5.25277.114-linux-x64.tar.gz";
        hash = "sha512-7CHv9RsPi558nAC2zJ6c3YEJl8nSwZhwQsSM3Wv25AwlUqy/zaQFxWs8595Ss6IOa5HwaMbkvRAbiWwwKjK18g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.5.25277.114/dotnet-runtime-10.0.0-preview.5.25277.114-linux-musl-arm.tar.gz";
        hash = "sha512-N7OLXKaeLLvdz69NfC0fZS5WNo88S8qELIzYH6EIolr79amshYVjY+puDhDIXOwDz/V+ZBaQ7d3wk48X03neMg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.5.25277.114/dotnet-runtime-10.0.0-preview.5.25277.114-linux-musl-arm64.tar.gz";
        hash = "sha512-EPWk90PYeVaI+rG55zbNduBL7LWlaQPZYHzXaUyBoKrO6Uj6URvkY+fXGe+KqpzNkJnvKmoPFdlV0jjOCRn8nA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.5.25277.114/dotnet-runtime-10.0.0-preview.5.25277.114-linux-musl-x64.tar.gz";
        hash = "sha512-cWsBVZtEMgwSRFnEYdyb56I5G2gOybpGoi93pzfrk8TjMjpzsRON3RV03MUJNMgq33q+eS1rvZU7iup5BhmUHw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.5.25277.114/dotnet-runtime-10.0.0-preview.5.25277.114-osx-arm64.tar.gz";
        hash = "sha512-i5UP3wmfNAIsuxGuLnNvo2081+EXIwlxIw6z4M2z0z82tD+H7m+MB2fFbmYZBmZnvPyOJnpvQWllucN7DJIVLw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.5.25277.114/dotnet-runtime-10.0.0-preview.5.25277.114-osx-x64.tar.gz";
        hash = "sha512-uGB/aI7PBs+fspUEU4PXVlvCyQV+eQ93FqKsLQVsmva1o9ZC2Cob9PgnJ+C29rBmxy4sVO2Wn8Wt6jiEHYhAjA==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.100-preview.5.25277.114";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.5.25277.114/dotnet-sdk-10.0.100-preview.5.25277.114-linux-arm.tar.gz";
        hash = "sha512-G7cuus8JCj/DTdExGtY05PsA6kUjIKpo1iq7+DEhUYta5CucGJX7gE9Vz6zseAlcryPAzPRNAHaRLH46WgAXhg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.5.25277.114/dotnet-sdk-10.0.100-preview.5.25277.114-linux-arm64.tar.gz";
        hash = "sha512-6Z8DhYuv+htB5n62KRt+nraPyJJkCXlNRBaYIJK36ANW5VR753m3dCFsHseu4ja2R0Vny3wNgV7NGevHGwf5cQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.5.25277.114/dotnet-sdk-10.0.100-preview.5.25277.114-linux-x64.tar.gz";
        hash = "sha512-TvO8F3u6p7o4zreM8BCbrM6h9EMs2MUuPXiyN81akr1mDpJndANqL8tRF19I/+vIpl3KVruQW8jtTy7P2MFceQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.5.25277.114/dotnet-sdk-10.0.100-preview.5.25277.114-linux-musl-arm.tar.gz";
        hash = "sha512-3kPLgWklkf9lCKm+4ZEH/gPmVRYz8D/WF88poU5RQtvcrtne1Aan6DnznY0PtLaqF0nCySW2PJPMFWdCBnmwwQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.5.25277.114/dotnet-sdk-10.0.100-preview.5.25277.114-linux-musl-arm64.tar.gz";
        hash = "sha512-xQhcU5dKu5lJp3TuYTuyLKoiu1EIgylqpeDPlZD08Tvg4ucHTkBU+bG/CdINCPL/IjWUSV6Vb77q6FxQjH8Vlg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.5.25277.114/dotnet-sdk-10.0.100-preview.5.25277.114-linux-musl-x64.tar.gz";
        hash = "sha512-ueSPDBuLIz8L7Rjv2E3DWz3/T2yEBSycykD8cBo00dhnRN6sDxVckc68PlQnYXCtC1Haeo5z5Zen09JGcmCMGA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.5.25277.114/dotnet-sdk-10.0.100-preview.5.25277.114-osx-arm64.tar.gz";
        hash = "sha512-GFo+NBuSi6GyGPt2n7DYz9cWLFZ8zUaSj/znTWBpugxJHkTpBihVM1KDp0fpla9EUp62/OBtPAnFybCmIsOTYA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.5.25277.114/dotnet-sdk-10.0.100-preview.5.25277.114-osx-x64.tar.gz";
        hash = "sha512-yvcOuvEYL9gD5goF8veTq29pAuw2W9lLCZAmeXCfsq72EioDJW2005NvM7mPZGI+jtoMZM+K6QKCnCPnRZhxSA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
