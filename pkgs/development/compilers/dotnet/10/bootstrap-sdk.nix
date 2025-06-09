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
      version = "10.0.0-preview.4.25258.110";
      hash = "sha512-vWfi3rmaeYjPakVUAA/UpIxiLPxsMocAAebe21qdNAgo8pm0qzlEvt2JB94HCw2i4v2pHzabs62l67WdS5djwg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.0-preview.4.25258.110";
      hash = "sha512-gUHQwJMibQcllICsw+sxgSm/ceKfpAPhxVE1Vm66x2OQp4q+x0zU/AuvDkR8gIj4noJ/7+jBk1lhI0l58WbS0A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.0-preview.4.25258.110";
      hash = "sha512-VfeM6G0eQyv3IFInmAmu9+fNZeBZPbrcv+U/z1HDoCj0K91fqS4zt3fz5z21+zG8DYEAlTF54Han9cEZFHR20A==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.0-preview.4.25258.110";
      hash = "sha512-cIjmBqaMxRPEEXInf6o5AeRmah9/pMUzqPcakc1AJqz+Ciit+ns2tcN4ykLlgoVAyUeG9v3iO/4OVPijZsVZnQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.0-preview.4.25258.110";
      hash = "sha512-6DksjrXQLPxpormAUtVZuLMHfcpNdCCH+9mKJSMiS1K+EaPI34hV+draFvcCJetHR/Vlcy+3VG2swZAi31cDGg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-uuslaUWSs49xZFoOly2UdnvOC0fJcA7Rd5mLx0PHbDvOz5gySJduHcnEyrZf0q0yjX7Hgs/xhg+dZU1Eqje8uw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-1guGT2CPPJrlcRAnWl2cl/Jqqu1X7Sqp0B9r8H5NZKhal8eSaYnC6Bn5DL3TYYA0wPNbrbUZ54wkSWHV4gArpA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-t7u2DtlUkSFN5pnmsj6qlSJGjp9tw7U9cf8dI8g8HlmbHYjQFrf1OQuXAkj4tYbBiQjAGAkr/ykhNyDAm1swwg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-lSDeJGzErzirixErfLQetvl9TgiuXKPRcZMupq61g2f9aUwjEan8KdS5kjC4ZFrkfaR/N5+ct/VEi2kW5odBBw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-MVWtx9pN1c1cOn+uLQJEQtmuI2boJLxD+JGrp0hO9Z+ry8fzZ9syUsBfebttmYdBmE56iSJfg75BCPPiBrhh2A==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-iIv4axN6NGortCDDWnv2hEXDW9WjB/64ydiYQT8FHT7owwtGghkBq0dRyE7d8uowXsSm+JZkOnHPLjMr0p0Lcg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-oc/ufL4QLBzTqrHphJ+v5WCY5pwU1mSEapHhbpLScOu7wdAsmVNhESXVa0k2wNsYMfOUxPA/+ztQ/EBOXI+BgA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-t8HlQpH3NpM441PLmfmblZEs0vz/EFUV2VV5Lyk4djEice1Ozv9G2rImmFv6dp1L+wPZ4i30ROEhpcrP09I8QA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-1IUc1oMd94aJys8I4OlCRI6cUGH2vnh5YHImHE+95FoFHXCruOiGhURmnrGeKX0qXjyjdDspqMuks0eiu7NyUA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-i8GunHeJSaSYPZYCuRxoatrJrjKLgsqEXNB9Nq4neHrK6douI2YSxZEIuDFOYlWtWrqJWXPj1Bvd/HtIaw+KyQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-zZH8KOTdzjA0ZTSJ0JaAiN67sNjlc8sH4uI2Z72CiCIYgWrSsGGc9xB8UfLWtpdc56VUgK8nXOBOhGEoKAbKCQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-EnBkJr7HU9Ry04aklgocx8TDSuwDfMIu6IJyq0FOGDmxIrbftIoycNg9uiQIntzpGYnqclYTvxpmddYjyFAgLA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-EPzA41GT9+m4+1PI2VuYJV7brN8IoVfbAZ7Mf+9vhoJRnEpkHTKVzbRb/Or5MEXcruLj23ZJv8nlavBZGt46dQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-tPHg/NyhOaJD1VOkk7rPmfeCrGCgZ82L7rduyeZf41wZhlfApycRRqdWZuDBbbPi4ZXnBmr6ZbiAknhorVeS9Q==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-6RtyWlpvIBR1rRiJloG/hLKG7jX7/dWnTOoaODdPR/1XMrvJUHhIgxh84qZRcDAhnTW+SSXmrWXVgvBFRuKDkQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-8vBMhAkenArNqzb2iRwWJJRmqgQ2PCa5lNMFj/JrfeIHuvhLCAN+4zvLj8+WMKPVYD8uIrUG0qKLvEqimCURaA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-wFj0m2cPFDkSjYR1qJrTsdV/m7YTxo+pC/aY7R0adVWZJQ4n57/HdzB5ZHDfsGfcPueRQ+wzFyoMpQ67FLrOvQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-49V5bfRKEcjeqRy5YUSp5Z8ttGBw0LhDc4ScGKnZcvI/DXiDO2F5tLcCuyUALeyocVYqhLMzf90qXs9vkFDVnA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-Qv0lflOQmXTGb3B4Ex7087VvZXRu8IzMumq2ij/pocKm53kx9cMjuWp51LRqy5S8f+iG9OMtg3qzHrrYfy0Jkg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-C0StqvgEE4P/6k2IA3K7hfHOg6NaBtw4QsYo+WBNe/+Ncm/LpkAz/kzswIpEQenBKHOiOxt0gXrDU6wKoiZHKA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-uzd6h0bZSwGJFj0pYewpPGcO321uuiKiz0g72E4AmaGArw4SLamqXPW4R7IvxkQwBgH8XdDvl5JiYh1Q7m8nSw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-wgISlUvkDZlpXe349zD3sbJWGPgYbt0dixg+JewPkW5wx5fUc9dkTBX6i7IZwb3IgmITO9WenMaJI25ceK/CUQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-pI1iX+DJ/QhC0OpCmHw9tL4FAnK8bbHKi6C45cryD7h8Vtig48LxyoOpyIy5qv/N7UYQcZVLI5gn3V9a87KlNg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-vCnb2RgQVunOTzEQNCfl1tqx66PVmnq9dNgLLKtWVxjIj5smtR4pjv8PIUTsXa6eunl5Sje5LuCghAsDYOuEhA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-kxLQqbRDypZACsKMnwuxKk/UGp9poLAgbs45S6cGuIuG50H7o2l4lg7DScBU0FWBIjaUbyb+gEKUyT7+f6CWOg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-/AeNVTpdH1X0wswtB821nx5tDKL7pVxhOPbHt9zwRbqxvIdHOkAxKZwxbhpDu38I+c0sMYOQwdrekHe3v2p1vQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-FhXBAECkx2pTl+o02UWuJuKtGFUMZ3NZVyApMOubAlE0y9BuaV6pu/0a32DlE4s7vVyoJAayWyspmw8dqGyGSQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-arMALatifYSYEOsWnO1WVu5+QO3YIRdN0kIcUVS2zaWblFMK9g4wPBj/TV9FwwfXN+fAuehjhLv4ZcdkKEzozQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-2aTTaiEyzXR/Q2GuqxpzvLt5F9Psv4tI6+0+fZfJYo5f9uK1N6ccMdjhqyJH65Be7qdFvTUZsK0upOcdmRlb9w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-CPXT1/j+JIuPx85z2CTOUSNBKA/Ru7ViiMt3Pco2gznFAyWQeiIFzBNJh0Hh15xSkKZnKBQ++Dea1J6GXMEgfQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-W8HRshU8mCn6SvlAWzwn3pQBI0u4z7tyHVvWzOqoiNbWjfOST8Dai/K1xSMdqUaB8UDd6UvslW9vICLbOgBMSg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-XN2AgOKMX9LAyrQc/z3BOtQIWnlTuCb9b9APjfY6xP3chc5n+5TOqpVh/qQVNx3/nIHl6TeZ9KxuB7mYxH3E1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-klhpghCNw87bBhxvKxqA7xKWDYrDCWlRXTDhcgrK3jz/e9/B3eig8kiIIIWJ5sTBdrBSaZBziYPbgGBj9qH2hw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-TPyPwxc5nmvfI+qzB6Rh5BsyoXoSqkb0fC2u6F+KdKjPs5sji0N8vqJs0oD0fsxcXcDipGZ29KKNFwjm42EzQA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-faMYtAbsnq2lajDY+kqzYPGff562MVOB/wMG2xifD9Gz1bKiSo2GLR/wwJRvIWlTrb46Y7Uoa5O4AK6LEX4sxw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-lzGjDryEGWgrjzo1Jn8der4K6xVMN6VDDOwSAUkShMEBfQDZgmSFmkF1qFYzVdsdkaKyLOvY9ojILmbD0Dlirg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-MOC9ECT6SNDvKWe0GztteB2xjMmxjYvBo3IMBoT/u60pj3Pq4oKvbvdTWXswKYnXdZbm4QMbWXW44kCbkI28SA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-Fj1f1/paElOi1bIGX7lnRV/EpgAe2MSJueYnTsubIYQu6DL1dO01XE0npm8z5InVks5MSmswTY/l8UibOmm/wQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-lWhzsbJRYcJStaCn1U/fmg8Bcv/3c6s6Ba6hpv7m/Y0nI+eNvRS+aOoHF5Bf8AgXmA7ukhrRP7QvQhxcvcLX1A==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-kuBEdbF4mtqnayGH6xR+2Qh5nO8ipPVikosW31oAJFSYsxMwNn5EIQ5Xt/XSuRNM5APVGZYu6i49l/ldghxDtA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-PBvBPCAWmvHqbFDLO04gQkqECQwCEyvxkltpkLnZVnDpaNH+V/Dcqe/EgowxeTIjujjeRn335zfkDAiJXEq/rA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-G6SLD+2vlWcmL9K1JlW8cj7p7yNlB5DPvZ2LOoSm1TOz8eabKAFbUzAhzm1vjjbx4kVjgYGQjk9SxUb0jlNyBg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-Rd/49ec4URHYjz9G7aOq+MlE9jXirUEzGNYvIIxu63ah3iZj6rTL9hP5/yHJFgOy2sTSGCNjmftiRp2LavS+fA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-elIMKxh2SsVvxA0TA+uZ4AhEfZgbjYawBBO0H1zEPMg+Z5B68qBl4bcPRhhlQvfZxTmXLDGv8ME53lkowMAY7A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-9tUkHEWZpnmpqa7lMnQyPaajyJqGNtJnbfhNlfddvH8Fu8w4iFIAmEQs/qdYspA7GZqPsl8HAUGN82TEYiQAqA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-+yjaVe6Jic5H+VzO7/G9hLuyG67BpnL8XdUrlq2OCPJwPv088osfM5JFUm/WAU/uzmOjD0aaWU6W+o8X4+YmMQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-gLD9VVXQqUXHkZajhIX9yYIO9Y1x/RtVhNnoSAfLVzilYJw1z0OqdIUtc7VtP4yLSIfSelT8Vu6Nn8i2DD4eag==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-+j0RMzpQi8K2PySVEatGfkorswWpRrYWTOzz0obbqd7Bj9Br7+0ENIBBuZXDESLZGDok88Go9F+6zcICKYooxQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-VLW0msNDaNWb7XOjJ2Hm+Sz0QIem0WnktK5rFgmNZyfDXtF+dpm2c5XcrDFEOPdLLBTUtLqow75XlMdShieS1Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-vT00SyyvuADK059SOMzkuBH0uFNNae9H+kjZ+cNd0GvtEpdjdJButYtB4EY/iDKUETZvAwqCPMwfeymdnARDOg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-UYU9F6bt9yhS4Q4XnbbXrZkWXGt9mRU3Sf3QLepGLEGZDTNMZ/qQ0cwECm1AFk/hvqtcsxR1Rf+Y5QzInY1Dqw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-Lc5B0EhxRtqJ0aoHwqu3lhzQ0iQi/sSB6ZE8zHCZ4Mmbl7ksbXdLfOxviOTp8pEvfIw+OEi0LYIP2H/v9uxtqg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-1pdCZOxyNRo849DdbceCdGubemC/Ef7APxQfQcxute4H8cX56H9vuvYSMigelNtmS6cMW40VCjZCcoB7WuC7tA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-bqAnrKRGSbNZDaS+KVM0HzB6kXDogTK4AWw0u/HHqhLzbQalY53Jj4JNUyCL78aYUT1ltLXqWjbxalyXr4SWjA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-tTKpp123VyoMl6cesOqUbBa41hbnSIwHL1/YdebYvBlqv9rO6E5NOZpqbk2L9dF6gwMEVuPgQrxjLGH6EDqGzA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-Ki/aU3comxUTo6NkvDlSZY6Og9UFDFzN1/QU6SUB2gUyiD5sm+sLTg5i5y9tqjDncXfGW+GsJYh1eorOM/uBWg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-Ary6XYzkOkvpH5tLF2UH/owM3EXlI1GgaKaA7yYeJmA5qk2l4+gHqA/e465MgbgNYirRm4Btwp97Z0t8sEYsjA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-b7ei4mhIRfcqyjq8v+D4SNjUWmLkVbvIf/JFAEXJo3SlRe3JSP7jS1MLW3d5D5/0vUU0l8IolPj5drAlywNA5g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-MSCi3QAeZzaTWCoiwVoYJ+KicB5II2wozy+aGhowc2/E4RAAm0YlReD6o9YWlGW8KdNlqlcEQQS1zmu+qFz7Tg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-DTTIMNHk4mhq/vm9mfnNjGl+vJiAVeNOi1Wv8CzAHbbqpmd1VgAIPGMj1a5tyRpGetr+E6LuNJr5hhdjdI3zpg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-oyqPs7vbl/j2j9q9bxZrp510Kvl6vGRl6TCfV49MrpWXkVqMrh4MNkrcdfP5I5TR1q0FKPEZbYIbCfogoJSMCA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-zMT94I7Yjqlmb/nElrQ4KBS3PymsoYqcTxOKuBjffTpx/xcfPyTMNrVYW4ybuNjRAE3mUqx/LXHrQQ/+1k3oCQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.4.25258.110";
        hash = "sha512-SefFQ45L6kcn7UVPM2G3qFhDMZpgGqvWIFSITGvPW9BVbJfpH9Q/Tg/kFPbrfAVx/9DtTN4HBIpA/4RCeNY0hA==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.0-preview.4";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.0-preview.4.25258.110";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.4.25258.110/aspnetcore-runtime-10.0.0-preview.4.25258.110-linux-arm.tar.gz";
        hash = "sha512-ZMQ1mo01rBUxKthEWH3uHSJ/IH08m6Fu31DGcG+Top0LjTOIvRdUdJFlLxQjpnv79CxMeuiAr75CBhXlKbq/dQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.4.25258.110/aspnetcore-runtime-10.0.0-preview.4.25258.110-linux-arm64.tar.gz";
        hash = "sha512-fFa8BN1VFSkfwpqUTlAc4na3Iqp448Z5GIy5/jP74GPCGwTv0Py7phAT3XORTnpLQ4YmqBbAtvnPfwl2RqbSCA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.4.25258.110/aspnetcore-runtime-10.0.0-preview.4.25258.110-linux-x64.tar.gz";
        hash = "sha512-D6jWC9w/Y99JtfP+XN2hNxOj+b6j58FQSAVD8rfDs4cfQnj8BC1vhQQ0FGlQxJNGBshI9LB3vmmuQ1es42twdQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.4.25258.110/aspnetcore-runtime-10.0.0-preview.4.25258.110-linux-musl-arm.tar.gz";
        hash = "sha512-1rbk8vVIsN4rpIyFpV3mBnUkPZG55DOqLEwDZnmuuBQjb5z084UJ2l1HE1KjhFqDDh4C5bxelxrNuEFWcoVibQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.4.25258.110/aspnetcore-runtime-10.0.0-preview.4.25258.110-linux-musl-arm64.tar.gz";
        hash = "sha512-kgcEGeDfHsldkpAKFJhP0SJtpgToFUYIU/6mGGvpsDqL9ODHmyQ4EqxU818pPNJHtHjxvYlsO2U8tSaAjM55fA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.4.25258.110/aspnetcore-runtime-10.0.0-preview.4.25258.110-linux-musl-x64.tar.gz";
        hash = "sha512-oj825bLubRUzuHcKmxuQuAU77SxhNInTtcopj0VT0M3Hmtn1CABYoc6GjHyD6/RyfeN551eu5F3Afe9SjlXu6g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.4.25258.110/aspnetcore-runtime-10.0.0-preview.4.25258.110-osx-arm64.tar.gz";
        hash = "sha512-caTBSU5/1Xb+8RxckvzQ7Nkh/gQvSWcEpVqW/6UUXXk4xsQ1CQ4oXY/+FQwxHz7Wf3WxwePRktuUKfNPUwH93A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.4.25258.110/aspnetcore-runtime-10.0.0-preview.4.25258.110-osx-x64.tar.gz";
        hash = "sha512-WqBom031NMIiW3gXDitS6LqItcJD5lXwqxxYoRNXAi98fX+0GM8UXX2CYT06OykNaKWaNNX+MyIcbYeHGbMFAg==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.0-preview.4.25258.110";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.4.25258.110/dotnet-runtime-10.0.0-preview.4.25258.110-linux-arm.tar.gz";
        hash = "sha512-QD2cczE5iV4+piafBUpTJN+HC661pv47t0+guuYiVJYt9JAlwBsWIIXoxjPIm0sshAN4Dw4yLXiJ1doWwYbKKg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.4.25258.110/dotnet-runtime-10.0.0-preview.4.25258.110-linux-arm64.tar.gz";
        hash = "sha512-Bq9SPYENOvwxGoODDhrAOwGzb7/JPs45XulU7LI4rlqv1APzMDMocOoxTytWnyR0xyHBLHjRYrG/K1/QddbCMQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.4.25258.110/dotnet-runtime-10.0.0-preview.4.25258.110-linux-x64.tar.gz";
        hash = "sha512-GQKyMLHyAP7HdioUscfhQBcqFVvYMS1TOOopDJUHphvj7X3HmV5Xaeng9VsR3+LudYWmVOb0tEZOWUFUY8563g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.4.25258.110/dotnet-runtime-10.0.0-preview.4.25258.110-linux-musl-arm.tar.gz";
        hash = "sha512-lbpT2Zpfrx5mZ0e6zBn1kwEf/WtpQf9G7JACt3V1kYVXOKBliFr2cJnZq+bSnTYjNQVXysQzf6WZCJiHiNQvzg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.4.25258.110/dotnet-runtime-10.0.0-preview.4.25258.110-linux-musl-arm64.tar.gz";
        hash = "sha512-bi0FPzwi5PYN8urumja3st1caOX8DQPE1OUfm1FXpav63rCioK9IDMZcPuo9X6eNTbos86u+dOzMBvZIXh0JFQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.4.25258.110/dotnet-runtime-10.0.0-preview.4.25258.110-linux-musl-x64.tar.gz";
        hash = "sha512-Q5h6kWq2+S45MH7AXRDlDiPHJ6dDahQnK6hgYrdvif9OKINB8eJtbpluS2HyAGqsN+twDzwjAMn/J8O26fiCog==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.4.25258.110/dotnet-runtime-10.0.0-preview.4.25258.110-osx-arm64.tar.gz";
        hash = "sha512-OqAvgpqCTI42rs5Tx0esxvpBKZOK8E/jBePfeuBmbfFytgpoeEGg+Y2J0UJkT17UL6FNMaE6Dn3hQfnAz+mmWA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.4.25258.110/dotnet-runtime-10.0.0-preview.4.25258.110-osx-x64.tar.gz";
        hash = "sha512-NxfTJJu4d4zjaWgB7VcRW1UrIEwEgNOvvrjm+j8XufTqibe0FU46vfWCfqEcO2PX4pHnYgtI4LWpox0RbAWUvA==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.100-preview.4.25258.110";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.4.25258.110/dotnet-sdk-10.0.100-preview.4.25258.110-linux-arm.tar.gz";
        hash = "sha512-DUJ5oLNYU85hmiNB/jwjdfFfr9/GfUioXKbB1yEue/CYz+v+SEVdrvmK2pNX/Fg1sH/7PFSSNGVNrDn+2GTMkQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.4.25258.110/dotnet-sdk-10.0.100-preview.4.25258.110-linux-arm64.tar.gz";
        hash = "sha512-OMJfofQzWQel5YIQs0OxvtC0RE75SjNlWNcLqz8nY//XhhVeZmQPwI/Z/ZSb8GHE9pRR+rnApvE04BBKRAz5cg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.4.25258.110/dotnet-sdk-10.0.100-preview.4.25258.110-linux-x64.tar.gz";
        hash = "sha512-iJeINwYYlV8vsQAFqmah5hfVLIzQF4PXgZ5DaO1cYLlUGt8Sb+fjB7dkwPDyg6TyCcDSAX2ZLaRDK2cbc3ZbRA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.4.25258.110/dotnet-sdk-10.0.100-preview.4.25258.110-linux-musl-arm.tar.gz";
        hash = "sha512-inFNo+h7IdjYG3Cae45AHxrg9747rLmCn7hN4ptIxuc1UFABiszHL2Qt05Xo68CPmYfeuRQO2ouj8abL5BE47A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.4.25258.110/dotnet-sdk-10.0.100-preview.4.25258.110-linux-musl-arm64.tar.gz";
        hash = "sha512-DvGTNB9FCheZbkeeQuaQh9cARzWJ8NjczB9OgHLxBM+D4GXjg2H5/crYTMgWqrC4B7grJCtvZ4WM3lknJeQq7w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.4.25258.110/dotnet-sdk-10.0.100-preview.4.25258.110-linux-musl-x64.tar.gz";
        hash = "sha512-eMVLzIIt/r8dSXI4fllP97vD1woCYJOT9Nk66Q4svO+gCrwWpdf++CAkRqqQV965GU774t+DwHjCorm6Yf2UIg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.4.25258.110/dotnet-sdk-10.0.100-preview.4.25258.110-osx-arm64.tar.gz";
        hash = "sha512-s+AtjwF4bom8T43nEebtrpe5eeJwl7JnOqUcxRJDBoUzJe3JvomeukuoG2dpLNgeTHujiKFfhc7roEBPG9ySoQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.4.25258.110/dotnet-sdk-10.0.100-preview.4.25258.110-osx-x64.tar.gz";
        hash = "sha512-W4sGZhLE3QnjlVc0zf+7pwPObgPUD2iLSxNnmAsIQHrgeyNPUhnyIl7C222B7d0CxK+6ZK4QrDGIKnG2ARdTng==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
