{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.10";
      hash = "sha512-jTH9mOX8W/5tZiOc2PUFxyePfG2PrkLbzfQc56BKUdPMz0HVnh4NI8XzzXXVb8xuBsi3vt99IKxAAJ7rjxvkoA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.10";
      hash = "sha512-wm6HQmklISelRc3fmi+wrOtsd0MOLZ+gmXUPBydF8pJuEeYatSSBMkcNOJqjGLdXuuMkM/Ub8T1qSNOUviutUg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.10";
      hash = "sha512-62Hc/ZoMyaMlUfO2WLhRIZYCbcfqo7ArXMIwevBwDf0wW+aceaSD11iS601gBcGwp/Q1Hz/ZCTUfeYvyYeSNoA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.10";
      hash = "sha512-6nQwLH8px/6F8XmHGicLZ6Bnx9clOmEbnXj6JLzKp6TkZCVdMlulIO8wVrsIfYn9UUgZ5M0FjEivcooilyvmdw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.10";
      hash = "sha512-v9n7AjgX/3+9siDoUnzaaOo4WiceOTu0P1DtD1WKD63g1HRB7X6SgjmEULG6wUhY73HuWu/mxGvRg/oMXyCCKw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.10";
      hash = "sha512-dQn8Z1iypqdntr/hfuuEt2qCdJZywJtociOEnl+jRp2wyEJcQNGBtNQfDT2LWqNj/tJjSY+a+ncuXT3UnnQvjQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.10";
      hash = "sha512-cA9+iEQ0AikuCnRJ0ASaZbPPpVAINzbEbwR5I4fx2wrch2cdARdSwP3CQK1OAeR8IfA2EEm1jKpgT5fLJ7emHQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.10";
      hash = "sha512-N3VO3kok4zHBI6gQC0+x6e/36ebf6xa6dIEzxMnuF/GGEgjseDNBSRI6/Ta/ACRR2LzwDE1CcLp5leBzxMkyAw==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.10";
        hash = "sha512-BtkyaCDhxkQs7ibV9jQlAhkjlxwOzBr03rdEfhihGgYthOiTwkoqqzeB7vxrvP+H/uJgwysggwzwSQpaNGlJlw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.10";
        hash = "sha512-Jt7crQk/OPyv1hiNDqUHiSoqZnujYPBSbU8sZ1bYWRTtxzw7g6lv8SqdrYmUbAfsfleC0gC+tCi4By2VY0IWhA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.10";
        hash = "sha512-MncgNrn5CKRG+3XKUXgoNl7dM+5RyxMp+rPD5AGBf/6o2KNLp6bdKLXGjuuDaVnbmkH8YKSJUc6lGpxuqOT4Yg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.10";
        hash = "sha512-l/BeXXBHSRwffmPVdY6ASNqL1Ny+WC8Ej+SQoEz3JVON9p4Ybl9xcVXx5UlMiEiwwVT+TnUH3mEjv9/cc+Qu4Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.10";
        hash = "sha512-sGuQ8KR1T/iSkmIiULw8qIhjh3jXdGtEfXQPFpV90k1mfXAtjg28mbmCZxx369QU9c4X805AftOHZwth6m810g==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.10";
        hash = "sha512-VeIp8DjQwmiW178AWs50+zRjFlh9PiVy5soW8tqapgGq7PiBxerD0si3xAnXugU7jHx0Ok8hNKPIa2AeaERWiw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.10";
        hash = "sha512-JNztsZCLyTsk8IIl9FGwHIXJOhFFa3OAWD6wQfGykGw8e18hnNrm8BZT/TkV+1npHkNRltsgC+pilCvGTFS0kw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.10";
        hash = "sha512-+z/hbOCAXri5KZHR/9r13ekpE5Yd3X0N/yIOK+ktBGXvWLdo4cZEnPL3tihsP4dAbUw6opzenRnFMu85FN7jwQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.10";
        hash = "sha512-f9fD4rStb9clC4Kdw2oBtCR8a6UKHrGQwexldthR9K56vUbJfytX3YYwMqfyLNhpTpDuFrKRQ8lmtudeReykvw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.10";
        hash = "sha512-RycMOl0s4egWecGU0EPcbtRrk1+rccsYFsELZQK0P+x5TGJC9aaBYf32E+hOz4RV0bFg0MGdrwTSIXig2xK65w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.10";
        hash = "sha512-4pNmDP63npARYQmw+lIhDQOI99Euog/rynCfABdSCVj6vB1FP0puZuml+pwawbGnIoKd7ZgaBYf4bjfIj1RHPQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.10";
        hash = "sha512-ZNKweMNFH6zFDFs6Hc7cuu6FPDqI1eg9b6H2ztmpR7Sw5b1mp7pR0tEohWuT8fuFC6cSZpuxLwJ3LvG68fGrhw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.10";
        hash = "sha512-eGKkNO23lblqy1iU2tBS3RfOSY7C0+sgcxutwg9ewIs6ZnwkbR9Y4supxsWW4RJHkOFjs96az654VUlhd0gEOA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.10";
        hash = "sha512-KdCyl/S7WpbK4gw/E+Y32fvbrW0GnYm+gfWMqLvrVyS7tImpnyn3MXR6aI5KtQWSRSPieZ0agSSlb+lCmeq5Og==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.10";
        hash = "sha512-k1mXRb5ot1WesCpIbswWPJ93CyhGlrIr+AlVVnWnjuo2h1n5blsiUssuzlymZFHCJBsWlrEsIi+AF1QQwYMxzA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.10";
        hash = "sha512-AhBOcNnE54H0zeADnWjsQYnNmEGXO0uUeW3Tb/si2hH4FVsEEj45VcL72bkQwOkg/GvpC3QIhKbhJcpWvHPBAg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.10";
        hash = "sha512-piu7U8YtQkilUXLBckW6DK3V/WOYafIpcbuska49JEND7LOcJnwhHsurx/5E2mbYKNhw/4mSQ7mRg6gGg3cDkg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.10";
        hash = "sha512-sYBKVezo3wUeONOGX1gsLIcIbAS2gTGy1Qq5iNYhlCoBsFA0VGI5+vWOc3Y4XCoDAT/T3us23Sa1qaz0J1qkcQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.10";
        hash = "sha512-clDN1mYknwk1TDvCjCSw0MxF6TCXq37UNPfdwlIJ8IRballtIFNT8nAXE21a2uE+tyQvRRb2WmB1l8EK5Q0/OQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.10";
        hash = "sha512-77QAZ3kJguh0yopM0rw9amHyGt5pC7fX4mS1A+U5h86xIFAqVO3EwIf/M6rewj0n2TYxjf26zm4dbdCnR9WOjw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.10";
        hash = "sha512-DSJF9/jWOVIqnutDo8qHKjZS7zJA0z/ijonXqbYByMIPXR1IlLDw1imPafynCC0fOjBgR5y4R4/6xeY+lfC3Gw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.10";
        hash = "sha512-+xARA3uXnKDW2XIArDA1qXNfYTGeV5bKtRPexvH1zU7sHS9+mt9IaQ6zPu96Z+gAhlmqEqcKozLMgVAJlpsFDg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.10";
        hash = "sha512-jKI1C5RudJ7/WkxRkfF6NLRdFyQwc6OBpssmO6L3PLRRIWOiF9LZT8kIqAFlvEI4RnMWT7l3a18ZYGAbZWQo0w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.10";
        hash = "sha512-nafxACk5Z3jdOB8CzxJF4PA65DPRdsjdpFghiTxSfRzAoPNk+WHe1YEV1lTC36O1HePQxy0p/Gv7S+xv+g/Rgg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.10";
        hash = "sha512-zm8yoWBRxlUlLr/6e9rqJNWJCofDnv0/eAobltr/tSo8rjsZVPb9vzczdqCSPLELreqnhT6Z7wmdFpOAESQfxQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.10";
        hash = "sha512-fTMFwna/qdY28Pzg4YEGtTeduuOqzAhkEDOVOkh7sQe/VyO6E/TGIRXjenOMxZqACKGowe4lNlVwd5saBAMKfA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.10";
        hash = "sha512-5dk1ER7hl9myUCaaKSGFODmsnM/XSr3Cyo13ti+yipttv/UDy5xand7/2vH+YLrasRo8lFkA269DKrRgaFUibw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.10";
        hash = "sha512-gFxz2UvSnulSNGn/XlmCrDwY2jUkd7UtYV9vghVoaog3jCwjji4Kfd1YFTiLKYy+A5+sgIhBqala54lwo8sRKQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.10";
        hash = "sha512-VEhpJyS8wwmP6rtuzobmU06QFzLyMcGfA5a9GbhC46fn84+z70nMBl15gvZPWMmcqB5VZei+DohpLlOnkX/JHg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.10";
        hash = "sha512-y4+rLKkFKGFew6c5UIkXPeraVqhsnA2qNeEgEWnbYnPwLjAEORDw09peAjdxAwakHwlv/j12F7UdGs2tjCuayA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.10";
        hash = "sha512-fC4zeYX85f4NvC8uns2wEpqU1FxuWpB3FZQySCnvy1PrrUeO5q1v82xAXYoS5PwyT+esJBOcn8zv4odLLDnOsw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.10";
        hash = "sha512-HO31muFMnV7wl7wCJi+vIyWpDCZETjL0Nrkyq6AflGhb19jOCOUn/+lIkERWrvbpcMtnpxO+D1MvGg72VWxVeA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.10";
        hash = "sha512-dEFPSx0rf3e1cb7FQnpczaWQdtY2MZ3so4p3PDXq+c6nJoHzQ5Go9PiDTfJInErvuHndCkgnDGPtEOXWPZXjhA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.10";
        hash = "sha512-qJTYIaLNTVDzJDH6MuRJcF28TEiid4YGSCd7E9tLxhWtafn0N3SBOxvPkG43X8U/VAqRlnef2IZwacIBjM89cg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.10";
        hash = "sha512-f1GHDkwqIUdn6QmM/daaVG7L6/LLT/kKT9TlIn4SkspwbAbhCdoMSIuii9fT6rhpKvSgM0/N1cej5p457knIjg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.10";
        hash = "sha512-FBW0xpiJK6Fwb6qlxNEYaMJ2klUNGCDihrW7pjr4Ly/vZLCWbN3+fvOBhr744KBFkMwzcWY+RVzlPxxKPx+H+A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.10";
        hash = "sha512-m5RTYSvHMDhhekHIBOpE+ydjVh+yYZ2TCSFNXTSDHf/E/jntSL3ICXO4SU9t4iBNU/KH1hxOaZ4sEA0NBVHg4Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.10";
        hash = "sha512-uh3DqyNvqgqSYYGQsZ9msABaT6DfWyxWVbXoo1aJx5+Aoph2HMd4hASlVwFK8kV7Hfxw274MOuj9X6rd6wLS3g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.10";
        hash = "sha512-J20ErWVUMXDz6bQIkyrmKbGLcTpvgVTwxm0Ps7iFkK7LaAQL8ZWYkDzubuRu0VXRcfcnmHlxB3ccCPuUBulKWw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.10";
        hash = "sha512-+7RMvtudiKm56zOQ21SqpdT3kX51BC7a+wOaK6weEtQEbLHFZO+G054gneIjc0o4roUkYdqdq/etuM7Bkob+OQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.10";
        hash = "sha512-nn4uNK3/AZQ74RImi9vUF92sm4zFxkgH6bSNioaZ0v1z2BG4ZUZPazGAO7+mvi3CzBqblwy/+6T/IaBcPslQFg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.10";
        hash = "sha512-k3DgtNRobU6eWPriLb/jLm3dknw3HZHRh6lXLIAiquV12FdOhUfvGJG68r3YVo2tb4dOCUFKfBLElyeTho+RLQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.10";
        hash = "sha512-QWgbs/CSdrSsncROqEtmkdiXBE5xLkCoF766Qv/SN9egO9TBiQ4LfMaVsoqpMPrzuUdNQ4oL0JEqz1Zi48oqYw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.10";
        hash = "sha512-2uLQry2nFKlbvUp6F2WQkB03xdFE3dto/Qc/jifCS3RnBT8/Qp6xNvdlRypjlqfyKIiia6ry0ymLhGRfa3qUOQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.10";
        hash = "sha512-UukhmPFuE7OSVQ+pLHZKFE5LDPUWnXMpbi3RZXebCU7xvQMUvV2px+qNkprefvFxZqq/8akyqZnNawhR2y80Sw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.10";
        hash = "sha512-Oim+j+EbgEgFeOxyEZp6QlLGeVzr8Yn/hXM5Xcx/xR3fj8FrMzQlHTRYVrxuiYCqhieZap6MDBSPS6Rj9O6OGA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.10";
        hash = "sha512-h8FumxGXn+dVTj/uj++rAcp/qfmxHAL6doMtFnw+0KYYt+tbsGVdoeSBu2XkZOA9IfJrHzgDft55uTBstrjttQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.10";
        hash = "sha512-ttV8As1u0LjTs82nFDIclwpzV9M4MN59PKvSHEZ9PSmxOLXISK1Yu6pPUGn1T5zEud5oSTBZ1pwfhyeKuIxDrw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.10";
        hash = "sha512-JjoooPntqOXl6Sl4/3Vx1MtLJSsqeDqOvMXomX5qF11W8D81lk0VgJYy7OyOPhIUbsl3GIKLthrVGHcT8NnL1Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.10";
        hash = "sha512-WMPivnrgK8ebUiDo5kreJmZifJs32mC1w/gm5uH/1wA+N4sfBHP/5uiLKYjuLCUHWSOUDVFcnTs8SUyOVnFpCA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.10";
        hash = "sha512-fzenqK18er5hw7LvJZOyoDwYbRod1v0b69czJcoGA/6REoqumLnXDgl+4glhg4aFgyam1UZeSGhuz/i+Sm4Dug==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.10";
        hash = "sha512-4yUt757dCovjB9pWFOJLCSy13j8+X0nWLHbIWXIBZr3rFViTDmb1/Ee5Rmojgp47voK2BvRkDsauR79MCDXJSQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.10";
        hash = "sha512-v+y1PesLbNKveNdln9wbtzXEH//rlpPTTmISuoHBJSTEvqvkQYcPAHA75FA3ZJfAHoerAZ0MilhJMQCyFyq5Vw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.10";
        hash = "sha512-v+vutaIctLzqgAslzdnF0jvajbHfCAtLwm/gKWNFP7iuSHiokMwiasxTKpiw/uBv+VUdNGmKOgViIAzYqAmCJA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.10";
        hash = "sha512-Thf8u0x5rRf+/1IRBo8HZUVLgHMN5mY97dB0x3DNeHcbWs4MM/S+1BvF7zzNueP1s2+fKci5pKNSM/PszrxS3Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.10";
        hash = "sha512-/FOMmkX2AagTyyP+pT3gn8LvWxvlg7pKI+kG4PvUJNbUtyB9bbkt16AmtjZUjMKcn1WVA/IhYM52cXnJbI7gsA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.10";
        hash = "sha512-5ReoWUX4NhoT/fLcdxncsFucSrAf9qml43Xmh8qOYzpj/cXqX8Jp8vmcXuyXW5SRL5IeaxROA1pekkmy1dRt0w==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.10";
        hash = "sha512-E5qJsr0MBnG2omiOk5GmeBBCRCized/HmpmSIAC3SGztKuz6eMSbOUcuk35kD2iH+ZVPmaRXDKClE1Qj4WMCrg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.10";
        hash = "sha512-sNHnfGMGDqK6dtlnronOc2D2OteJpnTC+An+9LJy7tzNSH1IiRfD5PX0OY5DAmbpglAQ5dbIbp86M/42SVq8eQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.10";
        hash = "sha512-Yb1UypJH+Vvhnlkybw1gzS4WS9tAWxQ/psn/MnRb3qf0KjQARVEYauHz3rmu3/DKS1y5LZvAcm19ek995qFoGw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.10";
        hash = "sha512-JbuWO4IcmZM3zAYbx31XOdaJkf86tD+HbgwotStsfnc67XpWywjJpIgRvTFEVA1D/qZJ7E8fxjwdKXpm3b0Gsw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.10";
        hash = "sha512-OGjSti6J8Yu+DPOeiFrzTH9yFf+W9V10gbFVExSN3YwXK+TLbx6BDqqoQXtkClPtFHVqI95dDcpOnRBfaLsTxw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.10";
        hash = "sha512-bzc9oXoUm+LJUTaU7KhPJn1mOG2diT0Tj1u+lY1P26jJmW14N5gTj7q5wyv/JQ8XkYuPnbakMyqX634+Ewqc7w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.10";
        hash = "sha512-UkDXcCKtEP+85Px6PqnaAWBof0NmrMj+r5TntwdfCvyipcf0xQAWT6ykYzy1YXiIJB/Xdp+8W0WVPKiTcgpVfQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.10";
        hash = "sha512-OgApkkQ0tw49zUlL1Zn0W5T4OmlZwXV33vtRIx48D3mjezPhYczFX2Dj8W6OCLeu3kkryKSPFb4GaMTRN1BHRQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.10";
        hash = "sha512-KmQrSBWHmNOd0xDMsM0oDKhT5zJ5gNJDDjV5F+S+FFTmImGI1O8PkXuHwJ4N7ff9553e0c1kIwiwt5dfS9R1yQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.10";
        hash = "sha512-ZPrFs66uEZbdHkaAbv2ODqjuLROFtCEGnu0AmbCCvNfPh9dI35ywmDboEKE4urYeMqdi+EAPq2VjpG0N3PMy3A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.10";
        hash = "sha512-0QqgTnNYbvhM5g/aMTh1epbCexRZdzQyQwmgfGJcWiqddsQ9yUfuo9dKE6jSZO4Cia5jbUDJYsZmvicblGzukg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.10";
        hash = "sha512-F6vhh3lgBpYEEGVz4Ob0751nXU1XJdJcZQYldOk1rfteUGD5vwjLRlUz/FNF998TrLslNAef8QfGRcwK4yDbgg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.10";
        hash = "sha512-GM7wSReWJRO9UllnTFdm4iFOJ8S6gLKD1/HeCQQScF/XfpZuvmU+V3nbxPoeOi3o6ror6UDgAoLzpZawawi0NQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.10";
        hash = "sha512-DgMv3ag+oB3rLUs2/9zu6Abpv/KvZCfNRbWNtefs8zjEEDT4NVD85dDNfXulmG5ZNKymYh/oE4SK/u+5eTBGMw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.10";
        hash = "sha512-3N45wLtwOancsvOEeku4zntYb5Atmp3+t/E2u08mkVzJ4M+kfB5t4NHlx2myd79Ur/xfNjtTUb8f9S3pNBtRRg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.10";
        hash = "sha512-ctCNTU+ne/ll5/U00OXHcnsn3pnaPduJ1QR4ulihU9Jz5LzURFsOU1DyoBaRlhkpmCAjkel7boRt9wXLZkxRog==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.10";
        hash = "sha512-LtLLJ5VE1kal9aZjf8WT8ZEnpJHHCt2wgYlcIGIiFg48MhKjS8NRgZnfLuZilk6u8lQ6vJVB3FwD+fL1wS2clQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.10";
        hash = "sha512-ge/ZgANVduHB/8zdvHYmzv13y7OzkVEGmdABYC9NamGnNGNYvBhfQT2a1GX0pDzu2w5OmRJBLH3DBQFctOPABw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.10";
        hash = "sha512-2x7tsitjwPXMZ5xQgme+CX8x/kpfS+P1t9nXFFl8CL/pVWE0Fj7ChZ4dwkSPFA/zky+3oNftJ7SdFjs6yzP6rw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.10";
        hash = "sha512-reEJfxHqrChAilKFnbuxd7kH8iiLndgSsMuHq/NCB1RSuxRnG35WMv4SHO1gXbPcjJRez5wSVfdGDyj2dBioCg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.10";
        hash = "sha512-dDyiYntefAD7AMq2ZCRRJbFwiPN8OdQ4jfPCe2GBnFKBIGnWhR4Hx8BHTNwuoLvqLL09JJ+lae9uDAGk/5+M3A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.10";
        hash = "sha512-Zudv1u+dN0JadwODnB6MrdyOnBiog+IHnIEWvUanhgv4mfVTwNvZib8pSf16LIn20HHVC6tJNPu6YpWXWYehIA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.10";
        hash = "sha512-9Y1TCB2W7h/2GYoxI0C9SU09VBcjijiUyWA+Dwi1Kw9CvWfqruwPI5qhbFBdWifKTyOmMUqoLnYQEfftp+JIaQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.10";
        hash = "sha512-rSStQsUWxolcgt/P7rMj+WtUWImPMHbknL017a7Tda84khR2mibZkOYR9uF44xO7j7uoLKwWVSHrriS0yC/CGA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.10";
        hash = "sha512-OgL6i82BRwnTG5kaUOdx1waAjw0rVL1/KqHldtRfsgo6+gsyAC2sCA8WXbXAJg/eq9/wW6IjV0a6qdfMobpk1w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.10";
        hash = "sha512-5ugZdamA3a1q5PxWouxCTgZt0v5faqXzpSXFJWU+yNjT7RsRmDjKrYMg2/IYIPSJoadB+DVk4gizIlApkDrIMw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.10";
        hash = "sha512-KGRJ/C2p81Q9NlUHIP98NcYUT0hxrckxWZoE8cJzp9dNPWaMfAO7OemuPBU1HsnBNEDrFRvbI2T6chw0gBRIqQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.10";
        hash = "sha512-OFP6LhDSxCwQZtkPtQpAg1kZO5tyrrw+eNziRR2hQntADHk2euR5trvSKR37Ah5fLU/hWbBDxa5nlYF5BiKbMA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.10";
        hash = "sha512-D3hpY5NnpvIg4fNVKcJYYUwxfaFY8AHTvYzwT0D0tb0qcXKIMsJEm7lRM2vsENuhHn02tWTvsyRuo5h9XmmG/g==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.10";
        hash = "sha512-pMagTteRJ2XwPeJnonPRvA5A4v3f4F+X1iu08RxPwTXVDsS4xemkm1LfZgiyPADIrAsY6DBFLXvK5fZ0uaBigA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.10";
        hash = "sha512-fprLJDM1dWKqI3n2DjCVSY8l7zBngdjnLid8HZxdHn1Hr9m57k4wcbFc/otHfnTHcYF0MXPrC6VO4CgRYFtIkA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.10";
        hash = "sha512-aBIdHUFn4vBEIN/v9+8ix+C/7Ljrb9zgFp6naPO37XlvGTuOgYm4tc2hfs1wbjc3VxaC2Gzc2smzUwahicAM6A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.10";
        hash = "sha512-auvgyTucWFrK3TZnC6T4RfCLfePpms/UOnJks1b8hErIVOHlfTHZmsLMECKJKl3wVeFrEYfVDbzE9Ac8PDeFgw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.10";
        hash = "sha512-8B6BJexY8yGK9sB6/tKWoGfqCIdOJ2NtnaoHFKB4j07VHSaNYaHrzh5HEynC4pFF6kbMsyJqs9sU9T/YGZRigw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.10";
        hash = "sha512-ltjs90IokeIj6/Y8SdJ+IUXPYBJiruJDxYvnayPJKtDVdDUGRQNfpI9YFflgSWkoztqPN5H2OELUAiowOdxOhw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.10";
        hash = "sha512-a1jTRbxRVMMxi0wsqlnMLEoWYm0p1T04atL0QeMe+VS78G959Thde1GckB7e6aX4tv291/br62ELG7O0yUXR4w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.10";
        hash = "sha512-VY6rMwR9QzRKhuUVBCFSVwPBPIqH20C+F4W2R6KP0GajGfu6h1/AdtnJS0op+76fIg0qia8JFuW6DUhc3UmSLQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.10";
        hash = "sha512-yWJ8LOGQ1/pKyT/qHjGkU+RuWmCy9OsUe/ANtHA5kTHmY4g4RNwP8+eDW1K3+g5BESfaENlJiNiTnWwTn2CFQQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.10";
        hash = "sha512-qrxC9S51t2w84jLBttmTmLmS1KjHscP31REqw8I117VnX/R7861Aabj7gg0cVz6YiGaeBqgzuUt/yBiHu18xeQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.10";
        hash = "sha512-NGl4nsuWJgLBQobSkbOxJgkT04uyetP/Kv8JXz7qN6MV0q+MjyhYQY29H8ODQgSMi4viOBL9KHbrTc6K+oSD7w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.10";
        hash = "sha512-Fdc4ceK2VvksnIYLF7SFO6mtr3A6Ktsw8Xu46ja3BxawnHTLmgV7dY9mh0R1JgiandksQMOS6AOSjz0D9Ce78g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.10";
        hash = "sha512-PmrjkpJyXstmNJCyaHwOS3WdQTGYZa3Ik/ayjg+APgNSBbcP/TBnEGg91esUmgZ5k2Gz+WGCQS6wQxATTTJcKw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.10";
        hash = "sha512-feQLgFQlSHP+zSIjLXq+n4zC3jKYRAiXPJ8iY90nk2xAfRWYIb6redRB4dUhqhv5uaCrfi8W2r0AXZX8/GEkjg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.10";
        hash = "sha512-P97h50G0e61YXisIsZOWFcE/ldXH2R5gbX+SD+6t7FgmNQwaIl80xQMjEICfJ2uk9CoYKw2jWiwjQEdqoa9g1Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.10";
        hash = "sha512-Mp2Scz97QbDE1CKZli/Z4zDSeQGSjN4vuylZUqvLukTTGTM1xB89a0TLf5ooz6rZefyNecAY2WOP0fr+oOjpPg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.10";
        hash = "sha512-Voo3Y/uZNEaiWfePrWjKkpsgZBR1dmgwuCf/8sxMCSQ2MvVG5jYlb0z+LqQdWQnF35fPHDFOCKeXIek20hPFtA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.10";
        hash = "sha512-00BocEhDPtq4wrrkK4TN4uC0JLQvLn+JZpEAanMEQzN/ZOb8pP8c4RX/jNpPP40MqNNnsNOSFh9C2LE/HPgjHA==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.10";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.10";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/50a67fd4-a5dd-42f1-a3ac-e008c3115dcc/816972da008ae5cee7612cad9b6808f0/aspnetcore-runtime-8.0.10-linux-arm.tar.gz";
        hash = "sha512-+ui2snCk3JIY35m7PMEPClLbntNjC6ggVkAhVNJ8I4925EVh+FNIzxpPfivR29kQ1BOKke9mq+VoXZlys9BQqg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f93af34d-cde3-4231-a54f-119c328bd876/663b3c2dbf1ed2a3e08ac8e614060571/aspnetcore-runtime-8.0.10-linux-arm64.tar.gz";
        hash = "sha512-OkePkxDHSLdCfJHes7qD9MAlV6fXo9c4JSa23Dna09k4AiR1qyDwYPG07TZcexuVodCJzKUCpCMpjEE3m/+BEQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6d143cf6-e215-428e-bcde-9fd50ea0e1be/99652e31b3e0161a3f1f933e0bedf223/aspnetcore-runtime-8.0.10-linux-x64.tar.gz";
        hash = "sha512-MyIfGZZMywbLp0Qg2sv+W/0Db3hHOHCTEZ+POR1XFuHFqOBXIfIzWYRAm0NCPXm1HsVx5R8M365tnSorLZhQWg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ccbec918-1f15-4f1e-ad7e-b4d1a679fa91/f8fc5b5f2fccf1fbdf164132da8fbda6/aspnetcore-runtime-8.0.10-linux-musl-arm.tar.gz";
        hash = "sha512-RbGzEQzSxmhMMSCnGdemLXpqwVR0EB5in0fOASq+HGWqZ7k/sKBRKLdGL+PwPtxcukD8eIAE+Iio47J8hh7sVg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c150b15d-79f6-4343-8aad-7748ad4765de/0e0768e8874957a8b37415919d77a9e1/aspnetcore-runtime-8.0.10-linux-musl-arm64.tar.gz";
        hash = "sha512-xx6iRxYGYJa0i+XOi5/ToUT/hlg4L3sZPJw4jq20J5tkSyvHoCk8AaYQhDmdXonIlS+T3tkL6qxqAcNhxXqP4Q==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fd29b6fd-e351-4758-8c61-0d9c0a6813d9/8be59cf5b2537298eb59d44e472c6b4b/aspnetcore-runtime-8.0.10-linux-musl-x64.tar.gz";
        hash = "sha512-hK8Vb9YUX8aZxzhl6hKlmU5D54iUX+3NXIDZE2uUgq0NngvduTP19y/x3PuQ0G3C6Uoh0C7aELwQFfPkuGOdFA==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/05bfc51d-d738-4796-ad78-6f16dadd2382/9a64a66f30708e38b6470a480ecc850c/aspnetcore-runtime-8.0.10-osx-arm64.tar.gz";
        hash = "sha512-K8kXmEOTIij7NVDNPu6IpkXFttaVpWFWQZXwtFg/wMkHFiVN3pJQIL3aA9DgGB8El1DAb4OYoht/0O9bjB/lhA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/135424ff-12b7-4b4b-83e0-1d04b053ef5e/9274109d1ec702677474c148ad2af1ff/aspnetcore-runtime-8.0.10-osx-x64.tar.gz";
        hash = "sha512-euH0JLv/pSuB5duPHVkNZ8NKiGUOtXPQXJIiu7dP+J5v8FgbbOJnVY8Z/jQzRz1KhRO+9PXhiAzeA/GWBrDULQ==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.10";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3f8dea7e-13bf-4931-b11e-77fcc6de7ca9/37531adc6a054037c064c47dae4e7f77/dotnet-runtime-8.0.10-linux-arm.tar.gz";
        hash = "sha512-8GuHh+T4b2FWmVkiiprn0Qu3ofqWcBDX88oAgMhQUTz1ZXwY1HIhHOFogP9er8bIRCpWSy+DUdd8XdJwITyYTA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6c71a005-d902-4df5-8cbb-f1fd53cf14f7/658dd2a2a839c14173e3804befec6a7e/dotnet-runtime-8.0.10-linux-arm64.tar.gz";
        hash = "sha512-MVmf+8pxAkf04D/pmxCYsoeg7YIKlEtabtIjcmUcl9Z1McNKutvFLlno9wtPds0zEiHQCGhPP+79m+KQSnPjiA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ebc433c4-8f01-43c8-a1e2-bbe1291ba857/e073f3f679d7a4067a56e8f5d12fc0e5/dotnet-runtime-8.0.10-linux-x64.tar.gz";
        hash = "sha512-f7gTZ3cg0SXCM3/txhMbIw2vHB151ZEqHKa14Iv3gCtBLeMkjWRbZIOrI/P66DftAqDlIOMwIM/vLIiMVPR0rA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a254fc53-e78b-4039-91ca-38fb3e42535e/be0d765e74b082a5919248c97866c7cd/dotnet-runtime-8.0.10-linux-musl-arm.tar.gz";
        hash = "sha512-rsjIIFkaE9F9gKFogPpiKWHqOpgtXqMLJuqRXtjYYOlQCyrHruB6rMCj9QXqM6ZlA3CWo9vJ7ZX8zzNeS0udqw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/aa047a4f-73b1-4a00-bb94-1fdf28bdf606/533876a5403795f02d8071d6fc9be4d6/dotnet-runtime-8.0.10-linux-musl-arm64.tar.gz";
        hash = "sha512-Huyv4nKgce14vJG0yQCrcOwQLJ+Cztz94nm9mSGn50DunogVOKAKbOQA2dwOvJMF6M1JYtskMec7aR4QUmlOwQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/abd532e1-6dae-443d-a35c-fdbd5053e239/1ab2cb2acddcbd435cb6970721f0f85a/dotnet-runtime-8.0.10-linux-musl-x64.tar.gz";
        hash = "sha512-LW7cwUudn++TrHL7MrF6Yxjyr1vdg8SzSzXFkdzUBtpNSJwaTVgIphusLuFLQLtrDo/+m0JJAbcP4tlp3v+ghw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5fcb418a-d290-4fd9-bba3-d0ebe56eab58/e20afef70b5f56e36daf054ee3e09d82/dotnet-runtime-8.0.10-osx-arm64.tar.gz";
        hash = "sha512-10aWjQSUf0qH0k+/RxMJoDd/mQoYd+km1uUbUCIQQ6snDABRf1eKpT1lPhiszDhvVVGp9KzTawIz+2Y8NTOtLg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c71dbec0-22de-4f32-aa1f-8e7112fa380a/54b3ec6159d2f72c813d913afaebcf2f/dotnet-runtime-8.0.10-osx-x64.tar.gz";
        hash = "sha512-RKvEd79+tA4UHXFfiVw8WwkUgYVHNt3lNHqZcxkdy188P5bdk2DighSfHZejPXwIuTgAil7fO1xI47k9s1FxBw==";
      };
    };
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.110";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/090357d3-4a98-4737-af12-95cd0f7c51d9/d3c813f556a47c6e302767b8ee1d2915/dotnet-sdk-8.0.110-linux-arm.tar.gz";
        hash = "sha512-QP5sEu4/Vim45hUFIGVPmVqg7pgxXeFiN0IDDhaLFiJyGtZA0m9Ev8EfIZO3r6D4vcu5U81Be0V254rLBTu3Yw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/22fdf62f-eb78-456c-9a82-75da635a2dfc/d47faae423b4f0666944beeee63cb6b3/dotnet-sdk-8.0.110-linux-arm64.tar.gz";
        hash = "sha512-KGylYOebHHidgPtvm2qtLhBdbjk5z2djlBJ+SB6bIAvJ2nLYe7gWK2sqT2JpSjbtZsofPY7eJhp5CrtnZTfRZA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9d4db360-5016-4be5-9783-cbf515a7d011/17e0019da97f0f57548a2d7a53edcf28/dotnet-sdk-8.0.110-linux-x64.tar.gz";
        hash = "sha512-Pcckqt3tl7rmOZafixVgGWJlSvZWGhMv1lDsagOnRzoQYfj192BstLGksSfmzb+1k1S8AlvT8HtW4Khxa0tmrA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8991cc2c-60ba-4cf9-a687-1fc9c07f459b/12e0c566b39176c4c57f080c30754964/dotnet-sdk-8.0.110-linux-musl-arm.tar.gz";
        hash = "sha512-5YzynONaW3dGYQ8u3TVVZ1GTUBuZjafZ7FKHVcuz/cTSJJ2zOGRah4DUevRvFpw3wTybrWfgDIYNM0xGoBFAeg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a06e8e00-14bf-48c6-af18-799760b12228/8765ce8c3bf2e468a640084d3c12a702/dotnet-sdk-8.0.110-linux-musl-arm64.tar.gz";
        hash = "sha512-ejcF2layS9s3tRbkJd+UT6jPMqPV4lI5z6Sq2UpxbV8QkYMK1FJ0omEEq0q3cuDc2GeaaY2vW8NLJMtygtiG4A==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/47769d7e-7c66-4887-9041-caf21b3766f7/46218edc4901dc48740c6a154ae21b83/dotnet-sdk-8.0.110-linux-musl-x64.tar.gz";
        hash = "sha512-jjgxPlsWv8ATmiK6tkx4GPm2bbn/7U5q3sINyuhhjZ3CDGy+8rwks0QLZ5Vp4d3qRLB2YeQdRd4LoZbkUm9oGA==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8d926822-6970-434e-b77f-13db037f929c/73e8ebd5b9129e903e6833c8e755b1ed/dotnet-sdk-8.0.110-osx-arm64.tar.gz";
        hash = "sha512-bWTqXAA4FLD+9LW750yvnqUCZ32iLGdrLbAbuUBTokM+qaqTIGcUWAnF2YhTpsSoB0s/JK6Ld8g1lAJwiYv8zA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3927a23c-34ce-48e5-804d-a83c9a4110f9/5e5642702e03e8572f2f772c2166d331/dotnet-sdk-8.0.110-osx-x64.tar.gz";
        hash = "sha512-xWuCfacAPfcAZiq9CPWvBr4iOHlL9O0kl41hLkW5fA2ieSv7RSOHGoCjI7stT3aJ3p0hbu8ptlEIeV3sIKdBgA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk = sdk_8_0;

  sdk_8_0 = sdk_8_0_1xx;
}
