{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.32";
      hash = "sha512-+AuAmhSvO0r9AmdexlU+z6H+lPso7kZKb/98WPeQayL6i1Bc3Fai+JZ7k6rMOI576kdGDuKRYxguDm/Bdv3+gw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.32";
      hash = "sha512-faGZGdr2CoO/16EYlzbaUVN9NJmcMUnSG6rLs4mNQrnP8ee08u3gUCWReMZpPWqL17SaaeQsjaK7EqEm9YTICQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.32";
      hash = "sha512-pilmN36NblR5jcrPE9RktFl037TKxJ5lO5QImP8oz67cF4vRSFxwS39sp2C1gJywyx02vOUt9UdtbRUz7S9H9Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.32";
      hash = "sha512-aGtTa1Sodohy3lSuYpvvz3jkmFEjZt9bFCOhPMcf3lkgu7iAlsKq/8AV0Y1Vd7MyEd5cUVlK+Vfj++3wAxlfng==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.32";
      hash = "sha512-XKyHqn8rPieMlklHtZUkFBdR/jF/61AcLVhZ+YwuEVWij7p3WDcJNNnabjeGQMrqnekCkaH5QR5Owuv1ozn2Sg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.32";
      hash = "sha512-PV51b46GIJXJsuf5KxnPk9rTZs6ZKWIw/otOdVg+4aUL50t1iFONawCy1omPIBvxQoEXggnShm3BhLQEy4+b2g==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.32";
      hash = "sha512-m7VfisSYqbnCjK7ZKKRKP8xQ6YaEBiN49Tqq9tNt/N0d8hizvyrDUomQgduzmYsQfXeE2dXwD4AmSupjcxuy4A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.32";
      hash = "sha512-XGRrJYyifzbnVaMlqxfYrABwXuL6w4+rRJPZyRTCDq8ej5Yy9gEoMNBoaqPEyUR4bgsXSbeLqjbj1u2n3crOog==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.32";
        hash = "sha512-daUQ6+bkfaOGd8SkgvZWoMqVcOp9VyOUwomBeU98mdckz0zDbLNKifw0CkOSM0WSynLna/XbQniJeKhEDclatQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.32";
        hash = "sha512-eFNiQbRSKApdyZZw6u3Cx6dSD9qDIxlCvrFhbqbXBihvXrBONrhHdNgyg9NltasTIZIq3uaaVY0r2qXuBc4opA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.32";
        hash = "sha512-6sETB8xc2VF/Do/ESkTfBuNF7XWC/g7LIJMzL+hDRYJsqufRYznEoXK7aJbGn5oXBv5A/T3MgxCCIb8b6dOBIA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.32";
        hash = "sha512-jLmqB62vnojP15sYB9o32csCEm2+Um1WUfLECzjFRnennWnFQf3juz1dRwiKDiB3q8UmnoAhnDx7MxGy5hnBLA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.32";
        hash = "sha512-ULX7ACeDY+kr/2Hq6EDPhsxvGXnFY2d13FESgC2maVxi4YU3xlcdCW+8BaPfR1VCZ47wKW/f/qZb4ytYoDFtWw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.32";
        hash = "sha512-Qr6l5GUS81cOYZfG7ENkj/I6szPv4yMvBh9MyvAwpW3Q0mEljI1t29j+7Ezl4KePnDjFAfIlTxCqtcqNC10H0Q==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.32";
        hash = "sha512-F7AxGbYV1GM3MtAcbWzA0OaFlP5/jEamogDIRrzVPXZ8qwMb/wvFpb++naZoo5Of0vq8p00+65eHKA3k1dsyVA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.32";
        hash = "sha512-AVkYt6bcYRR8qy+umqDgzzO88uu/cuzOHyP/qzlKoEQMBMxQ1fRhwg9HSwf1Yt3BNP9SR9va59qQC4cSD8NG+w==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.32";
        hash = "sha512-SjkgDa79NPthEDtRJ7uhhT8aGXi09vtpQjWZ8v1McLhIGknNfmgVxRaLKVOlPbJTytEIrDRDMamFS8y5nN81KQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.32";
        hash = "sha512-tVnEwIiQpdSeT5hH8eVhGAYXU5lZvxqtL5U7zxFW6/FRABMcdNK51gAzGL0P8sezib/3aiwRXHXOVDhn4ybY1Q==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.32";
        hash = "sha512-0Z5OCSP7XEEq8kvOSMLHWlR8a1bWQwKvBpTPoKWrnynrAIgRn8QNr5Rw5QnPKPlJBgS+1f1Gdfd3OIy8rh1Sug==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.32";
        hash = "sha512-cPnrQw/XYyJLvUj1+Sr9zCNM9qWfb+//VRNYAzPmiQV7sTyjP0KTsMVycFEsFrRpsk8p4rPmincps6E6/twW6Q==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.32";
        hash = "sha512-Ch0+DJ7gugGcZ3kMFVEJCmuYx1/nq0MmmXVhc1LjSCJhTYUjsy7O+klB6bQp0zm/ZenmxnjII6VwuFZt9kp0NQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.32";
        hash = "sha512-7jUo12QBHMjc6m3O7sUuaZYlJ6p9fe5hU1fzRRVwJJQy1P7xgde3M0jo+1orBofB+VL63ypmMOcSs1/SD+xqmw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.32";
        hash = "sha512-qBgOCr1oIm2s1O8wq7SIOq6QljXt2i6qTgGmSWk0t7CR1lXdUessJ1C6u0QF0O3W7S+hRXiS3bf2i9MH3bHfVQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.32";
        hash = "sha512-G99O7q7UhDXAUa/wDdyCVmOKUjVses/8Upf+qJjlCnMBLDz7QQITlKa2gGJ1fO1o+n5opSkIA/89zbjrj0MKcg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.32";
        hash = "sha512-w1WmIArP/Ng+CFONW02UYilp93JL1ftmPSK3HeqemMdynAfffX67aJlKVyCCLpjLNA4fy3lF5tiVYiGRhsQgdw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.32";
        hash = "sha512-e2OfUeZqV3DgXJSRherHOGxlDp4yCcdymKfZMr6VqRb7yfXlAb7Du2/kaiMxxTw50F1r0uQkPJULkbwkBbrhcA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.32";
        hash = "sha512-lpdxpIyE2L47TB9hut693j0w+0wv0MJtin4hWhzoF3+33+wh2HgUOBSrNNV2RyU8lbPybf/xp5/pLvfdR2DLSQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.32";
        hash = "sha512-ZA79DFBoT7OD9VvY+7JBU5IL1XzGq7+jTlXKQfz5CWBpkE8C8HhglwmQySJsUcQtfjDNkQ2aZn7lPuJsgFQfDQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.32";
        hash = "sha512-sy1Y0IfTPLco+QY95DQu+fJXbQkozK78Y3F6FPq6SGPRUcqH6Xyl6nIsmz6/7UsGwinAwWNffJTb6pi/5CF8NA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.32";
        hash = "sha512-lp5J6kkZEMZHNvRepfL186Jz6ge2lCfsvvJI6l54LXHcl7u1Fg9fp3NqMwN6HmxODCNvpQPav3W2Kt8uA5xlfA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.32";
        hash = "sha512-RjFLIkVAtDjdE3EfyvU0m26/uKYyedWa0ZJ4n8JBHTG2RVt9qJ9Dxo8XSMfTqLOq2i3EKSwQ5lWIwOuNF6owGQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.32";
        hash = "sha512-xDcpMIbo1dygN+/B/hfWSilzSTiEFiOmn7Zv9LzgflUGJOe1JgWJRny3vwHfRFKP3WTmUNzLcTgVaQJjfEnV/Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.32";
        hash = "sha512-G03ORRPbGZ+E7GL+SjGOFZpU2Hiiy8/ZFY6TLYsCE29qTz9R48s2dpDgKxrpeUiTVYJ7+u8gmflVFQrUtRZziw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.32";
        hash = "sha512-pn8mRpxXDtYPWs9vJewNgd2yPEOdbzz0uA4QMpUHAFhfELZYgDRcDC01SVySnbO66Gxd34ypSj8yNybGGEk6qg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.32";
        hash = "sha512-fDgheX4OZT8VT7adBqe+AV1xchBZIrRzApC3v125rg1f01P7gr1OFQ5UtmNBFnD9O+/Plk28ofntRe1YJ4Wa1w==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.32";
        hash = "sha512-c2gRtqH74W+bFuJxPK7cKFnX2mQ8dKMNIE8dN6omVTaezf7BRzeU4PnMsHj45bkNy585Rnc9ffAR/+49vCkjgA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.32";
        hash = "sha512-VyeI5EJ+0m3dklHXYkQx6iRr3mJIshLDv78Vrz59uega76s+83yumpuN1Q+hVTLByx8uh6/uh75v4D5emTDovg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.32";
        hash = "sha512-xEA8rqX30Jlefr5fJ9dcqlxmI8+0up0Z8n5dblicDqviH5WJLg2ZK3YcXvJb+/1MPZ7srqKUy3HXChBoYcl9hg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.32";
        hash = "sha512-ZPbXOo0XwYptAUYfT77ATAbHPFj8bQYZ9MzoDLjlYv5g9u7don7o+Sx2mo/tF6vsqd24iGK67yzghx0i1kol4Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.32";
        hash = "sha512-Ne2s0Asx6V8W3W+AV1Nv+nRmS4Rw1nX3zK0Iw8SVaf3INz6I1HuUy44jbSxP9q5O6IpeGA68Bgsq7O9GYQQ2qw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.32";
        hash = "sha512-btCCZWCsuDruO/MmYmBOs0qRsGUqDYQeEl7QEPGzFy6o0SCJUYSClX0OFLuiXcB4kwCadYK4A0xZE/qSIKpWig==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.32";
        hash = "sha512-yd+qbgQYUGcPvCfxMRQBLKuNH+W7aGM8OsNbCgxMxSl2X30ixk+R9BsvS0pcRNaGSqPG13vFcbZWOndVff2Qeg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.32";
        hash = "sha512-XjO4qNaHPMTVxJQc8moohUNPm6ZmCPcW1+7y/tYawXmIzyRDO/wkpIS5LXd+57Nqlfb6X8lnYx9EayKshx4/sQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.32";
        hash = "sha512-WgaczMBRf8SjOn6kBQ2riAuBrwZ4CM2FuAI8/EGQGzixBM+jeVvAamuki0e97/1DkzZh2Ecn4ox2YppNRLg7zw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.32";
        hash = "sha512-xM5QmPKpgWNGi8rvaqTQJVTncxiYDcHg5ByjgvLt3aScd2AbB2o1ko48/qU/u7XpPSDygOWQNHSpRSz58O7T3A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.32";
        hash = "sha512-kPAbaMfIH0Q7ATLtkHEjIgrfS+JyshzVK1W1mDm47wbM3r0TW2Xripasb24F0EC0dqMSKU5CkG5ffmhbQY8vcQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.32";
        hash = "sha512-4/wpNL6/em9hZRI5tbZEuVDvrjq5r4vsy3ft/Rl5RJtXmit0WChHmth+xEQkkTjvWx9yigBz7kUoGBR2XOahAA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.32";
        hash = "sha512-GNNIc5mJgo2luX6PxkEr3C2WL3UpyjLpNwV5CFgIhOpX1Riao8wUarb8dvUtzmJxWlY9Mq+6SEAQB7CMFdDLuA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.32";
        hash = "sha512-1Xx7DgF3YpQ+oafv5qZjKpe4PFyH9x/bARrBpIa7lm4Is9q9IfovktDULp1zCEO3CEYfEsf2K/WkEMzfBp1lCg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.32";
        hash = "sha512-ls8oN1qxZhHNxtVDY+LWtRjqcidNVbiB0Hjc0bw/5VVVyntU2WuxRZh8MFGCc7H0WH5YDQXNfVsX+16aQIy25w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.32";
        hash = "sha512-uP6syMW8GQDYOLY8LKSUe7fG0ggIxY57TKgn7cWFi+D48QT0D0yFJR69I3f7pwSH48tca+ZEPg+k0/zQLZbluw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.32";
        hash = "sha512-P4YffxKasq6bF6/fCiVtjwvIAwTfqgM4krR/tAw23G0ad+lP0XziJUyR+vt+9W9vzO7hqL0R59GgxWQE7k9T8w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.32";
        hash = "sha512-bCaMVH1zTaObUT/YWTZcwB2DKsns3MtPWicptXMFyB3Qj6Wj+0FLOkshyu8zOslCqsxvMBNJoOcle9OMi70qFg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.32";
        hash = "sha512-1cl7WPE/atwH0o6m7T36/a3HI3vq4mZC46umcIeiEmK2V+zS5DIBU2KsjAs3c5FCXb2RyVSh+kVk5V7c8LZ3Eg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.32";
        hash = "sha512-NEDtU6ovD43rmo99DZtb37QLYHdKyTQQvpR96k3Fv42klW4qcv3SYVCa3DUdbdH6ZlVgVz4lOGZ6c5zmwvL6vQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.32";
        hash = "sha512-B3ku0KqSVb7Usi629yRJY7HWKKwd/j81Eyxu7DdvdkAEWKK34LpEk4HymPS/HWb5A2CPBwGnjPFEIwvqOMCOQA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.32";
        hash = "sha512-LkUJmIRUfCRLq9y+w/eW8UTZJFTj53Pnqrw70GuLG7z3FQ5z8OIgWqPl5vHpX1/XZunUfPmhEO1S1pSF4F7pmg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.32";
        hash = "sha512-quiMFi2X2kaIdZoB3RoqvCxsjXym3n1UIase9ijF94IPf72GuqChUDqbx8zIyWrNqCLPs4s8P7KUg2hCDdgt0A==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.32";
        hash = "sha512-bgas/jkycn+jEGP0fPytjk/HCeBE9yYWhLFW2W2RXJYb3uFz0BZpicIHy1pjaEQxXKSdMoeiwHRHOcRUKJtAyQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.32";
        hash = "sha512-uj8M6n7e/2UP47Xnr45pw2ryGb0OIrJ8PTAr+epTXT2tB8F4sehA2vfTlIrlsU9fHLwB9rKQkUxdnm+j2D5xIw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.32";
        hash = "sha512-Wq3Ip+QR+0ujFoZXuvt8vBsf5PkaIkUne0Nt0KYBwGLvDpqWQzCGu5/s2s0eoVjE9bGqEyJ7YiAlj3jKAFT+Ow==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.32";
        hash = "sha512-PiK1EFLJTxhx66PUNY0T+b8FAdpd2sczuWCOAZWzQysHfhumukW8YLmORVAJi7jt9ois/6f8Vg33t4xtoCXUVQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.32";
        hash = "sha512-+xFYLFOU2xCYXjNw2Cv9iCfHOAuZRxdUk8ZfBTZZdAIAdNt1iCHlzNSz430PwFntTO7ZB7LNyp3THzRbfILIcg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.32";
        hash = "sha512-EpaSn6BMEr7PMmqhpnN/26TWyKb7Mo+NNkLukjKG9UcVAaitah0coHMPS0E9Me+gPwYNnjCQzIxRaN2Dw+cJOg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.32";
        hash = "sha512-EHi2yVz6bGYSMbmv7eWhUkWlZtyeBWQ7wJ+uHMywg+a37cl036xoKA/CLAXja/aAGzcbmMsBtmZvD3NUQXDnTg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.32";
        hash = "sha512-q4z8NGbgXxgrueN539EIQ3r1qZwAxTvvflDpKT84BO0L9Jd22xwqINAiDsegPvV1ZcVPa49/y+MJC8Aeub+0lw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.32";
        hash = "sha512-EyS1BCY7Ey1fBgr58Ep+ZioJL+xM2Tqap81eQUr3jfDM2VPiLAflkjCVN1ix1Ul2IVGzQTvqLo9a6xPBn6pVRw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.32";
        hash = "sha512-5nSljLWLgg9FLc4Bs5oqttqXjI4jFLyEPg4GLLl9Y0rhW7aSw7bzqFQkiDGeIw8oB1y1W4OvGW0/9z8VJYcAWQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.32";
        hash = "sha512-xKIUxFI9f8EH9wnt+JEZwPCNbtIQvxNBWUNJGHj1/MM1H0g1r2/7/uIBDr1voPnmAKeKNi4zHBiLBSar7zvOyw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.32";
        hash = "sha512-KtGbOE0YppnwkgMcjYTgIvv4V14NUmiHlcxz8uPcHm+aFsIXYnIqUnkT1MgE9wYRjOxXIp3PGIb/E4tCEalnZQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.32";
        hash = "sha512-Dhnb10lL8AdoZF0YY6INxcmZEoAXCr1ZxFq+8EDkLOi/tynEgqi0Yf5dea0Kbf1/nSi4Girr2lgLdA8QWpNhxw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.32";
        hash = "sha512-URWPybDs5eFnyMBJjJUXjwd+ZhNNGQCipjC9IlXwfa/omBd3fFNx0N29OhC1MxnhSbZ2IuMFa1cWNeHvr4hIaw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.32";
        hash = "sha512-zCT/t7A1WkDqz3D224RgBtTxvU22TTADlEaakH64QUkwWc5c2FcUYNjs/Ofrmew3JBkb2BLMVxngtg5MNBon5w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.32";
        hash = "sha512-/r3i06sUBBNp2YqCFaKMJxmvo+jPbR9l5vi29g4/+0orJKkd1U48Rode6FCUS/bTl1UFvzEm+IBfHR+2rf1Lhg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.32";
        hash = "sha512-rAWws/Wja7Sr0IsgLxCf7rol1oJO6IXSefDWV29hwbnI2sL+ILXqlfzFu+1RqnZHQQJyi6xizcUFsr24r31e+Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.32";
        hash = "sha512-qAxrAUwnj6yl4g6sYydvPAZqIZmtTFqUYPYd6GYNZL9CbZo+gkY2BDq+3aoPdYxXqPbyiZq6QcW4lQn4oOZdSQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.32";
        hash = "sha512-1FRSlU6W/ff2KowZXYbsT8Vbd2cmAZkpKDvV3uugbdY2MiWITaBG7Ib85je3gLgp6kwCtgwPK+asLv6p6RVhYg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.32";
        hash = "sha512-SiCXqJnfo2gLyYkeDd5ylcVGfG2g7PPug6jKvmgL7b+OAnsb1h3wPdCwtJlFSK3OBLY36OuWtDT/7GaKCQ/HUg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.32";
        hash = "sha512-ybL2aPz2T04znenc9sTL21VrwEU1BurWUSSuJX6CR6q4qwNlRVqIpRczNz9RNQA/eHmn4nWyW7d7gUFWWi0OwQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.32";
        hash = "sha512-ZhOz6LS7ZV1zB58gHy0n9aQpEyYjOOlu8zAI6b1Ey1wmMf+i2l0ukKiysppYylH8wQHsyHOr6u9BFSREJfbSYw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.32";
        hash = "sha512-EBN09fgn6z7jvc4jyBXNQ2Bl19+L6kD9TgBETqDOai7sxxhgUPlU2St4i1KThMDWNpsWM5yi4IdGnKN4zyIdsA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.32";
        hash = "sha512-2xGAKEi5per7PC5CptHH/ZVNckI5gWHeKcYt2XPfHM6PKwWAt1wq3ouKhFMS1njkzCvfRYmMMkQqQoIVR7jpMA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.32";
        hash = "sha512-Q8EOTBisV5NyWFwIdAtYFmoZJV3hm3J1KC1i3vum7h47cw8plXVP0FJ86Bz7oXhQYbb2t0ATXTfBKgUAsnpZHw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.32";
        hash = "sha512-pVBz1Ku+ZohMcQYD+E0zgb90gOODhdzWGd9DFTIAOAnGsLYgztjcP9Xks+R5iRCn3Mhfe36FKNao5nhxv46AaA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.32";
        hash = "sha512-qoynj4GB6I52OHmhj6Kks4JDDne6Ep06Hnf7Ju1Ds5c0Zm0UOoeIV/zQCgry++olcTYNoZ8ZAmuExh5JAuESsQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.32";
        hash = "sha512-Hbk39s83OqUZ1iGGgOnnzc2ILgTl/zHosgmBHN/uFBFlyS0YytbYYD2FrqB+8qt/1NfEN+Enwt2kGc6AZTzRHA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.32";
        hash = "sha512-Pl+f1RZh2JmpyxeEdXR88luIQLNMz7MK+xZCrr0sAJt6o435oREEqZe3PnMvZGu/K6xi8HElZtpJwTb4sH11dA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.32";
        hash = "sha512-Svx1qlLntiXHMxne/F44SS6imFYvoNaBaraDcHnUusXsIC2GiGrsA7GMRr4JcL1d97MCNOUNNZ/zsQsODPdIrw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.32";
        hash = "sha512-GWXNHEkt+DAmG+g5JO9YIP/EgRZD2VAjj7cbGLZ/IYro65vGlMQonjNsCrPIYoXkBR9lsNrPuhUIzJEzjtiSdQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.32";
        hash = "sha512-ECchTlGknkCWS3o086XJhvZfs4MZxmvrDdgA/ZR0Iu4FE3nDydkrwb/iSIWzSi2Znm+mQ6Lj+qPFof6z1d8rJA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.32";
        hash = "sha512-r3U13yGQus9mwtForPkQtB5Ya/Xsu5tjeQEfmXKhFr/o/pDRO/OCsO6Ol+19mDlTIJIEesrKZ9BD0EsrY/Ba5w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.32";
        hash = "sha512-U/ezGVfYQBPeKGS2Xdhiz7cD2e2oiXKE6+tyDoPVc0d5S8ulBdizlD/bAYVtaJs9dV2L623XzJICqI/oJtc5sA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.32";
        hash = "sha512-0K1QtI1qBPr/GfSfswzwQHayGlOs9WyE9AImnAgUiw4Kl4Nb7Zf2E9mhybjlNp9UR686xrsHJT747PuG6oiDhw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.32";
        hash = "sha512-AcglPcDyXX7fOTPSVuWmEOR7BfML+kEt6X2aIjPTZu5lG4nNTyGfH87nGVB1dSBH3ODoXUyMFKbxoimzjE+NkA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.32";
        hash = "sha512-fc0qOLLJ/4n8cs3Su4HBvS2WYejxX2R8onc35MGQA7Xzm20C3z7D5CcbFjJoIetbOg5yBNUmwXAzGjAiyN/56g==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.32";
        hash = "sha512-agCAxhOz24UzQKCaRd0lV/xdiSWd3lv+XyIuFjyaH5p+3NgBVz1EnXJ2hWEWmIMVxtZZM9Khztc9P7Ljskttdw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.32";
        hash = "sha512-QIxokL8SmD8XwiTliivYnr6nEDynDw2H8U1VPagzLKiEflxQJ+/EMG6eMZOyvxxDPDyZnIncpoDu5S3IlwKAMw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.32";
        hash = "sha512-iCyhiBgeaTYZvkzN1r8VWKq4GQShsTRy0Hq3FWOtfqKiKj+JMPn0cWaZs2Kw6Cmi6irSs+1m8DgUIkGX+Giq1A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.32";
        hash = "sha512-I7aVEenFvsRc2xeTBu3iyy2SG9PmA+XQjIXt3SrdL+G+QP7dt/QJlTnqW13kMSSLPv8q/h+cxaGIEHP6ExUwDg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.32";
        hash = "sha512-hN2DaYiKH3O3/iyT0AU4nmcrk3xH5HvMj0X9LdFZ7Y76DJu4cZ0Fh2YyfvJb7/odHmzh9TMuzH/42Ion81zUag==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.32";
        hash = "sha512-7YIJW0O/mXocqkiCydjmjmrJH6uzJS5cpCkb3hpGNvUj2iQSGaJ+6zTWrAkQ8/30R0XVjfeXnaix/hFAE5d/pA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.32";
        hash = "sha512-Qcd7ftHYuv4qlNCB5MBX9lhyv8mcZhK5A6bdsf+UQvMKLrCZwKA6j4kOQqzPhCaSvfzL0AmJ2a/lZO2lI30G3Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.32";
        hash = "sha512-8MVP+snATONyVfpZrCe0LuB49dmO3jgLnyRnE+1jQ1zg3eO+PY9Yz1+1K+u584kL90EOeEt7n0cxG4je9fNFWg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.32";
        hash = "sha512-B0EdUNiPJVhBfcbB5kiKsSdLuzSWDSeVjeFXn4JiF/ngTIq+Pzk2qgNdx0fUDKeKWO/CAON9S1GUgbGMH9/wzw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.32";
        hash = "sha512-A8nxkj9GwmSjqhtv358ny7ZKB3IiAEY0l3Q79KyTgCzVwep43IqAb88BBGIc6zhKV5qIoHd2GftY/lMQwXS6qQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.32";
        hash = "sha512-bZuHLUf3Qo/M+Yhd0WsMH48aKD9z1yDXNOlXKK+AYSbcuZ9Wv2SawqHXHMi0gLZGVJrlQn1FDGwpjs5pkqxF7w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.32";
        hash = "sha512-EZwRJznAVYjr2EzsjSPFo3LtIJnPkD4JSwCRkugitcMpSMAl9JVXPT5Rq2qX3bPP+Cz/a6UoLx2FVie6ptNzzA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.32";
        hash = "sha512-NcejywICODWcg4I3DhEYnpmx41ltm014rNRkxwA3QLaMS/UD3NYV23lxpg9bZSpp9ryugsAhpcW/146dFyRMJQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.32";
        hash = "sha512-1Dlaw0JjbBUWI5dGPLsJsIOtwaA5mEzCxyeFu+4KLX3vP1WDoxHCdsNFcn7OtLBnP740JDfCGY3kKlsm3IGsCw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.32";
        hash = "sha512-laqD6Dqlg94QpEugHF8D2DOD+DcytwQLQ/sW8iXp0CRDsVSiOuzgL/yCZqaOXtCb/bndMVKcXG3ncmVPOdNrNg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.32";
        hash = "sha512-XkFTOC2rqh9ATaWBiE69lsFqrx0dYeh54t6RKa+BAjTKbDZBO/grwVMAYXSbKcxm6SrwbPIuhisb3Bj6UdisqA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.32";
        hash = "sha512-k94MjLyfkDlfSuDtvZFEK6tnBUtGsTgsBX1QL7wtJxs1ONBku+RzdDnVSyNM7md0srRUxLD45J7cAfotkJkawg==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.32";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.32";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.32/aspnetcore-runtime-8.0.32-linux-arm.tar.gz";
        hash = "sha512-h6cXHEOMJLgRh/9Rg2sfOuFarSZdCm04Qi6f9fF2YqgbXqrahTiy1hjzAwn0e1B5PKcsQverBnTuDKe9WLVy4w==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.32/aspnetcore-runtime-8.0.32-linux-arm64.tar.gz";
        hash = "sha512-j3aQAtcsMgpFZDjEUkm3wCeCjWCXOK7DqnRtTMluvnDtPXH6S4j320vOn1/ORCFdMWKVq8LZqorh4BI1PbKaQg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.32/aspnetcore-runtime-8.0.32-linux-x64.tar.gz";
        hash = "sha512-bb3P3kmzHn+B2/COGfTwXesvAQd5dDBrgHFGfeDQQAzXCc2DGtl4F/jf1P7ci3ZRIZSxI9E8/EkYzG9rbxVLhw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.32/aspnetcore-runtime-8.0.32-linux-musl-arm.tar.gz";
        hash = "sha512-2oVsO3cwlkK4LjmHduO2PCGq15Y5jkWKi8ePxxNBLtDH3h6T5MIxnR9Hq21AwBBRiHprCQ3o8UOV0qR9sjDoSw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.32/aspnetcore-runtime-8.0.32-linux-musl-arm64.tar.gz";
        hash = "sha512-uqXvjfgE0751c8Boc0HpDCjrnz2rFFrADSnXWFsMq/NfQbUaY+XuejmDuveFKdnuTOzDjhZyL44w8NGGC2SzKQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.32/aspnetcore-runtime-8.0.32-linux-musl-x64.tar.gz";
        hash = "sha512-75GPwVbujoOU6TSzGlUUgDzGu42j9bOrBWuGMpFdRIFwI06gdNP8bJzmTCEjQRAPgwdVUfRPnDUKkTs59caqzA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.32/aspnetcore-runtime-8.0.32-osx-arm64.tar.gz";
        hash = "sha512-PMDTL4k+yx91ZA4auRlphMnt/jYbuLrPDPEHclWykpz3IbfMSemk+ZPgnbntb2NkdiBWbsb4CbkJoQh/3XC4tg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.32/aspnetcore-runtime-8.0.32-osx-x64.tar.gz";
        hash = "sha512-7ctc954Wpj1sHm9YtfGe5DSibowbSr2vxA/18M9oKo7nr5XCNXA7AZWawsFsO9l75s4qm2/LPGKHdIoPCOANGw==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.32";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.32/dotnet-runtime-8.0.32-linux-arm.tar.gz";
        hash = "sha512-G+AxJBZKW7PqepPVaKMN7ZqpMUPa1GKSPbkR809O69vO2vC1Ot/yajXadpSYRwVnN5hcB8lbRjrJlpxDOUeDGw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.32/dotnet-runtime-8.0.32-linux-arm64.tar.gz";
        hash = "sha512-I0Ny1a+XPiOViyCe7MvuNfQgmvmLfsyT8WSIhp7vBymqODzuXGzCPdg2y96ICQ7F3wwxfTnT4X4JBRQDOS6pzQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.32/dotnet-runtime-8.0.32-linux-x64.tar.gz";
        hash = "sha512-Y5oX2E5NUv7NYsfU5SjnvArjyYYN4lMMtBou5xlraeoYJx2HlYSRgHQncOJbT5E98pKlojb6GXz1080OxbpmXw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.32/dotnet-runtime-8.0.32-linux-musl-arm.tar.gz";
        hash = "sha512-z9wXFSsoe3FsV5YQFmEiSUBrg250N5uSFOi7eXo0nuh9HaPPLqxhXgcYmA5usH/Bi2rYg8/5VuSvmpQf987hhA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.32/dotnet-runtime-8.0.32-linux-musl-arm64.tar.gz";
        hash = "sha512-nSmpePwoLUSFFWVvjXr/pXanpDCB/XbxpZ6ERYQ+2aReJYuu7CqPVe0Rt7rTxt3J/uMKDpmla71R1VXRWwuwMQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.32/dotnet-runtime-8.0.32-linux-musl-x64.tar.gz";
        hash = "sha512-5ERMgsTrShvmO7rkjjQPLYB631Jf9E4S7pyaVD7ac+PIKYkFbF4ABS2hHsNzzeIDVdwcSi81hhWT6+kDTWmtlQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.32/dotnet-runtime-8.0.32-osx-arm64.tar.gz";
        hash = "sha512-mCiI6CireBX7FNH6vhvYIwZy3UJJkj5pujW+fFJy38QafXmBx7sSYLbjhY1IYUzyu2XJtL1dA9s8hfsg6JMKNA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.32/dotnet-runtime-8.0.32-osx-x64.tar.gz";
        hash = "sha512-9sT7SAweP4f2AuIZ8j9eE4NOW2ovanKnWm6LGyI52lSsxXqOhaFcpPif0EKsdg899YVRcpA51PtfynbjqaTNTA==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.426";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.426/dotnet-sdk-8.0.426-linux-arm.tar.gz";
        hash = "sha512-0kjt0UM1K0EmA5zm11oI9BMWsPhv45epEOO/qvs/B7Fg4mYYCwbDudkwSMP4vItjp8pkSmOP99RykrWat1TbxQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.426/dotnet-sdk-8.0.426-linux-arm64.tar.gz";
        hash = "sha512-iklpRQG7Z/Nb4NNF/sTsZgt+MR5tMc3kjiaZzJTL2QHXHcWu9hpCvDWIPgF1iDzCWZ9/b/SvNSU4G317g0K+9Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.426/dotnet-sdk-8.0.426-linux-x64.tar.gz";
        hash = "sha512-gUHQG9xT9gSu07tmG2BHB6ZCCfipR82Bv5W09RiVFZPXeGQGkZH1TqXoQ2KkCdprD2kHS/iTsoPX4M+T4r8gqA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.426/dotnet-sdk-8.0.426-linux-musl-arm.tar.gz";
        hash = "sha512-4greq3ltTyVxYh1fqLOru3l05ZhOC7m3vVFYeuzcGVaZKWys7G8/XXQpta4kMDEOiUKPji63Np0cnk1xlEevyg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.426/dotnet-sdk-8.0.426-linux-musl-arm64.tar.gz";
        hash = "sha512-SMznvfKHHWme1v8Hhfn5Fq95aZTRI+o9LAztkHnm79c7KHYO1u/+X2MJTSadECb+jv+wXMPprbPKkp4FR/QWWg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.426/dotnet-sdk-8.0.426-linux-musl-x64.tar.gz";
        hash = "sha512-0M9eIyVSF1BSfjTCSmtPwIYDb3ZsR7pPVfRHgoeaQHt0gUMgG2BrcHegmKMXWkPIkZP5SO5YsGGijqqkur/pVg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.426/dotnet-sdk-8.0.426-osx-arm64.tar.gz";
        hash = "sha512-F81AjJLrbO7cBtQfpybHg7m+Agxq5fNiStOgssJqeKp9CfODOAAxY6crsU1DdzHev1M8BFGlxqBd47HjejqlCg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.426/dotnet-sdk-8.0.426-osx-x64.tar.gz";
        hash = "sha512-RPU1bNjJapN1QFR99rcZlWNq/jWCe8OAR4VDzHt7PKCJZ5877gSY2z9jmb2e5rWCnztFK8/IXTyJlxRxLqPF4w==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.132";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.132/dotnet-sdk-8.0.132-linux-arm.tar.gz";
        hash = "sha512-ad8pwv7sXEN7jyr/SAaVZ0hpc1QYv6avShSf1tnhp4TXAJC7m9/odvwHzwULmEU51tHFi04uwmpEyrceTWLiXw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.132/dotnet-sdk-8.0.132-linux-arm64.tar.gz";
        hash = "sha512-L9Y6ruHY0lc90zCT87JQugZBcjf19uq1vtld41WTgF2yD/upCXC766qutc4wpv+vT1ZA8JEYZe4lYigwxX4idA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.132/dotnet-sdk-8.0.132-linux-x64.tar.gz";
        hash = "sha512-B8AH/ojASi6DMKl8Mt5aG7v6txndb64p0iXhpfDLs/oKnAuZh6S3HGmGhs+p520BsPTYSmfggpDYYAOX9s7z2Q==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.132/dotnet-sdk-8.0.132-linux-musl-arm.tar.gz";
        hash = "sha512-mz4MsmcVXYH5UNeLttYNfH0XmZfZQdgHYkhrXRmDlVNBUXBTtlnWTNy54GCGDuiAblwYdl9qP6yGma+D7iE13Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.132/dotnet-sdk-8.0.132-linux-musl-arm64.tar.gz";
        hash = "sha512-CvV4zb8yWMNr7jW4q/T2LUU4Dhmddr9cl5EO3ZL9Bz84Ov1C35EV9opFY+HiagsK4jmNrhwcx6FfvZJ+JC4TDg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.132/dotnet-sdk-8.0.132-linux-musl-x64.tar.gz";
        hash = "sha512-0gHSPQaMXDIMMSDAd0OLVwCuEQLghyCc7oyvNwg2cJ6r06gNEYS90TSwQXXfOq0SM8eVbme8xF/GRPx6z5Xbdw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.132/dotnet-sdk-8.0.132-osx-arm64.tar.gz";
        hash = "sha512-ab55ujK3Gl57Uf3jBSAX38uK2fOhXaUWII0fpVMM5WOK2ieqHHJEL5f3D4fkhxNuCZOyKTK3wA7j9xA9OMAs3Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.132/dotnet-sdk-8.0.132-osx-x64.tar.gz";
        hash = "sha512-szziOF8yUvE89N0XepJGYxocCYR1h709xUo227W5RQigmhZ4BDKJUnw7AhK/Rs4le8mGhYiRzEuO3pxFEvQ+DQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
