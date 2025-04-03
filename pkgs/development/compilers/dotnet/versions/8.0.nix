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
      version = "8.0.14";
      hash = "sha512-V77R9GDhlp+JKw+glAHcUGaXc15vfv9odTkqcMqBNOdbPkhSfrEqogcvgjBDMbAGyRLidAdObmFlgMGxLyI3zg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.14";
      hash = "sha512-baxYb5HaJmJLHacl1/lK3Ku1cpv+IB4ktkHvHIeSSHHRt00aIBs/UhB9H14rIp2OSGioWviswwgRv56tVz9D6g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.14";
      hash = "sha512-PEAiKWOkUDXDX0EEn+RrAXqyGMd6erYmpQy3zLxQ7Jkg5lIRB54OUmzAOZbJ4E9oSbv4skpWDc2faJWqRqscOQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.14";
      hash = "sha512-e45XYXqnQGgAB98jBceSfWQtRfWu1mkOeed55NlrgTG1pFPDHle3csCV5Fpnnt6MOLA1sxkkXhTPpW1JVVe7mA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.14";
      hash = "sha512-CCRUGwheiGabheBCY77x/Y9mqk0Z2FtRpGIipuPTU2fHs1eBUfXOqjNhxNQq6G/H5zLrUPkklxQQedYlCFRImA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.14";
      hash = "sha512-hmzIouncdA5p/O8YJaXtNzy0KNgE9Q0G6D6xe4hwzTvDpEwmSfwksaT5AbqtX+9G89VxdJy7UVMgOFNVabOWmw==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.14";
      hash = "sha512-rITtrd0fkzZVON2Z9guK3xnbxva2xv0twlinXLq1rAseNjjimhrNINJs9nH9/cNr8tG6lTNqhOc1IqbBc0Yqbg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.14";
      hash = "sha512-jR1L2sbbjqlnM85zk2gWRz9t20JP2LQJo2+jb16RBNetiVJAQ9nY8C+SDR8BV8X7TzIwbRvRIQM8acvJIUR9mg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.14";
        hash = "sha512-nfKaPD8SPxVE4CEUtktO51ijivZzQTfs/9KQQGlcJW4NvBcZ/1Oc0HX/tzzyuh9Bb4ak6uln7Gr9GsFzHDVcUw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.14";
        hash = "sha512-rbshrpuSXP8ki/PmxkunWQIBk8Drlm4MKO+CV9rq3cu6GwGhPqoIcjCg+Z0MazGH25KFbdiuqpEFe005bG1pxg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.14";
        hash = "sha512-EdBsWhiSrfuZHSiojFVcMUIn/+3m6Zc6oow4CG4c4XvhvUJm77gc3xRGcA1dOU37TTRVvKIZST+G8h+wVvfa2g==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.14";
        hash = "sha512-qdMOh+qTaqUKFOtjSY00IBxbnmRG6RunrrG3hvF26g2f/yuL5OZl5YZyxzEbhm2bcX23B/Qkoe0IamrZq7/+1g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.14";
        hash = "sha512-eu1Xm8zjehwn068VC0wQ7c1Mqw4ckrhFTNdI/o4Tkw1hzNxtUcCPP6K3CnA+tqzAAA/tttNv53lqpgT3/jbcEA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.14";
        hash = "sha512-Hvp1eNx9gEI36JEFXHsyNmGxlvXL9ZyNwW8BeVldKFAUBctRSTr4hXM1MRYi0xT0WyJfd97E4ty/hAWeMJCHzQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.14";
        hash = "sha512-xFDChwFMQTHlx445FpZLZTJyjDcn71k5xQXOxsrjMGvEl25ykIln+ogYCX4fdPPGYyEb/SSTM9TvNjLfPUcWqg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.14";
        hash = "sha512-wEdInX6FejF0NfBsMxMc3KcPTMODwINm/JJdHGSh4M0H2R/k5TAMsBlYSI3KgBDrKgbyO68J1/G2ZqByMPhBnw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.14";
        hash = "sha512-U0Gb/0pUDyfA5OTM3XumsgUUwmVv/xaJSOpAR848bUDpIEm0Kr/XTfhMjNtlTWVFxUmmVpefN44i8Ms9AWlt2A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.14";
        hash = "sha512-NtFv6/tK7ZiVPPWx/EhJYZ00Rit0OUnVIsbkvRx4aMSWg6VxihspJZ7DlH3FvZuYcKorOf0cFf/i9PuysGl/Dw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.14";
        hash = "sha512-ncS8oaRhux84YA3KF63EmoGPrmnaUbQEywO1qFQ0DhVycizjmy65OTzDA6WzDhDob8zlLMtP8yTtXmrujZ20hQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.14";
        hash = "sha512-jV/Es3kwWGy4yVHu1U77cnDwYUKeISf53sw+oxa6aEWmDex4fTRa/maywdzXNPohXnV3VBUTViZoDfvkyaWrYw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.14";
        hash = "sha512-XfUvQN8PbHiTktVFHbDQFNGbkQ1c+j6+UA7v4Pww/Y+fayE0qzXQbnYEDKl59G90zesrM8DQDlurdd5yzncwdQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.14";
        hash = "sha512-dCVHU+rKCt/z5wAnlKoGIgPUvF1A4lWsir+nVQ479bdEQAkbW1JQJmc9QIIPuJkpTFse6VnpNX3V85aQvhF1vQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.14";
        hash = "sha512-9D06OBULsC6rWITBWopjIID1Ojigh6vB40f+OmItRIDgik6bgFh3jGu15puHhSc2EFLCfm1yinGZwQTbyZ5h/A==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.14";
        hash = "sha512-ybYyzVFVmxiWINSlegKkJZfW8juEBocbhH4/Zg7yFz6K0UWI6/N42ZkGrXT9TqhM9STMU+Hi/sXl7sgNO5oVTg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.14";
        hash = "sha512-BCAj0WZ9hB97Q/GVaaoQS9xdEGLZTenfK3M/KI9oXuda4ww26FL0jYVg+vWhO28RHg+ZlQiLPs/uO4uDg77s0w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.14";
        hash = "sha512-Cu8rQHctwDHwq7OYcmk5ADEMFM3liTg3xmrN1oC8zv9po6Q5cz1vP8oOnVi5R84MMx/k3AkIhVozBHzMfmcRfA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.14";
        hash = "sha512-RFDIyrBMxGkcCBQwmv5HRrZQ0m7oYMQBO1TxUFs/vCfXSud2gGsi93zGUT4i3xoakye6r4qUf9huiKtlnAR/aw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.14";
        hash = "sha512-bVjMx5x6pJQxb2ZeDfA/paeLOYXbhHO7J3Cwr4nn1Is/j3Mtmt9z2Qpw1bk6E5zIKx5dMB0eTutVZRoOPzlWHA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.14";
        hash = "sha512-/KA7sVA7+ITz3mfq2LegHB83eidl0rcIjXU4tskhTuJy8hKF7l1D1XG+auS3e9NkThrzbk7Z7m5WmQEMO/Fi+g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.14";
        hash = "sha512-PJgFxWXGNL6OzcpOa7nLyprC3yRG+gSBgz+crarbEvd4djS0+5OiqqSPNBn1kRiqpVSKtkCSUUiG3Um33l+IpA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.14";
        hash = "sha512-7ura7+C0nkdjeb3X9Mx6klQSegpTnOjwtCDzhsi72HUyVmvojvpzZQmx44va0JybbE0wpu0y9bEO+z1SpKyi5w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.14";
        hash = "sha512-BM45yRmYa/XVQFCRHOVb1Ye1e0g1tXRZiLGiA7dSU6au24TFZWbdCWOwqwFiWKnGIZd9scmNvhXA6K0tIok6Qg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.14";
        hash = "sha512-H2jBl9Lkaox4kp3p+vQWXzw4V4SABsIMXfpqlZ/WlBfrWJ38v9Yyr57OSRhZO/wHHCUnjtQFVyU/yylh/FiDDQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.14";
        hash = "sha512-uGI7lmwN8qfxkznt57OKAZQA6/HGiSLvnU/cMGk9e/8xXZ+PXFko9FVE+EOSEwFR8dYLV9VGBRefyxlHmy5Cjg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.14";
        hash = "sha512-L72/lHM+XIxpZc8LAoV2ZytHnSJK3g43WJLtibmw6R9pLYgkl/kD2pIQrdGj8CAluoyFiXBdGAPnYGZwmvpG1w==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.14";
        hash = "sha512-ljXkPGSvi5uTwk3dDeNIGmTcL+iiKghJeifnfv/uj2re4J2CL1Qogb9rTUSq9Wz6QR/HG4ugw7MA2253QgFUMA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.14";
        hash = "sha512-rSACOMwu9QGIr/1o0OjKr2rO4s9++GtQG/ZymCc7IT4NP3++k/12ojSHgpKb4eMqExKB5DPQuCgoVNojqcoCmQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.14";
        hash = "sha512-wqyH1Z74biUPO2OrTTKsXJ9TP06umG09STThodA5VGmRXEbhAG+q/teXfo9Uoi6eRcyl70/hQlI9YqcMdfbHyw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.14";
        hash = "sha512-UKVwdxTBPtco0irMJN+VbaquRMvWII1DaViPsRxqTsHIuKwTPRIG5W0/sQ+0I1HkvJ4l6zJ+1sw1BED9/DqznQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.14";
        hash = "sha512-bSsxr71xZmh8Yo87NEfJnJb0JOiXLqhPTDtXjb3K7iQI2y18nK6S9/EsP0bH3zCZKzPITud3Uo2QzKJ4YrqzZw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.14";
        hash = "sha512-uUZOHCbx4kuHJTHyLQbWJOUG9BsabqPk+Ln9/7x88TOVS3eMPxhaqYU5anfjpcsVdrhb7asq6qxC5Icryy103w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.14";
        hash = "sha512-goeC57QuEPTyNw1TwFOAXO/JkyUNlqFEAGJTlmj3Eoo2PJ1kCgdmCQC86lTr+IBC3uO/RLdjx8Kk6yAm7tFRtQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.14";
        hash = "sha512-k21UqMI+ZJgWQ5FR1bK9dSgt4YAmAm8kMcvlR4wMN0CqzG53EJcpYwHPkYMH9MFUXQCOmEmVVvZWf9uKsDewKQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.14";
        hash = "sha512-MrPaupmZVpgKgUDxhAyYRL43PpQHj7ktgm22AN0sHwvW6i5q04KeMjrftVz3cUnLbl+vEvTsJ1lxH8x7PW5vEg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.14";
        hash = "sha512-oi12yR6WS5e8mLReIppxto3On9Ok2DJ82pi9qKwGdDOjPi7+osInCx3nyflzFgscRyW32YH3/JodD9KfiAnTvQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.14";
        hash = "sha512-i3k29laNQf7O4ZDV3brN1kwlbWBTo+N3TWkpW1atQS5xKeYnJylLNIFFnbaIhM8hanaI4FdExy8xw1btVyVV8Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.14";
        hash = "sha512-K6MJrSXlSS2xj8wEKdmD4WPFUm1lAnwQGdwF4lir4sIebyIg1nTnwLhtnIOVwn5tQIY25f0Ly05xUSJlzGz51Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.14";
        hash = "sha512-ndfmeE98qPvmmNLeRjgv/IaLnYwvVwfLRgdrgu+KN72DxKUVQXn0OrKyCxODvPjnzEy+YcHpAjIx7xwZNp8hZg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.14";
        hash = "sha512-SPk6qR29oxUrM1FNqThm8ESSkAyvYhqAlc9bx3fkvzPX4u3Pg9cJkhYdlNd9EdbrDldUoyBhfUgHL/delmyUNA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.14";
        hash = "sha512-/MPLARzf8FLw1hYclLPFaEqJN1WSPHpbydW5A/c3tdQWhQpqfaEfJoB5rsQLLF2GuAg2QJS2e7I0dYgc1KKVZg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.14";
        hash = "sha512-cXAsRG685drGn1HBeap9r+NxXTKcFjwkXvpr3UI1CyJKKdMWYoxR1Fi4WZmzEXvysCEQPqz58DqzcKEcH7V74w==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.14";
        hash = "sha512-trfTrwYGyVKzfkXmZbymIEfmPKRLqS76k6EERxEBR2r2Nh/r0sJxhfhMF4petHhbDUmYSKbkx/xLwKKTgpF0LA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.14";
        hash = "sha512-43BdW4SfpjNhCSl6v9yNZvwJRqq1/eP6Pto+v0ce2Da6tkXTX29Pwqw33dLmt0mGiwHHur0sHaDB6aQIjX53uQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.14";
        hash = "sha512-1vePR5K6hT2TBz+fEbAVkQl5Ju/dyETeIsPRfZmxAXqD10H9YVKVc0IyU2n3FBnwMoioE4Twz+U0YFI/Mm0BZQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.14";
        hash = "sha512-S7hFf/tXqrqUENm+EsYxpVgJPv+gAQKsW9FR1AAPwpWc/gMdaCTKFk0joqyJQdcyf8P6NcS7b0eGUUUpnAqEuw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.14";
        hash = "sha512-uznLiEeLWenfYzBeJQNHoNJt7apxwm7EU3ifVncDURN1Mm+YgYk82ok9CCW5JybQ+VYJQ4Y88S07IKRjLc3uQw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.14";
        hash = "sha512-eee5wySPpV7juEjAtUQJD96BRK7F+U+GUT3mZ49uI7ZCvD9mXGRuKXLook0bDsWUbuzDpyzA7oH9Udl7XL8Hbg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.14";
        hash = "sha512-nHSoXmypBdzIs1QodTa2j9Lbhx4YTNg8QvWF/u5h+r5ZL4CtATEDxi5N5DdRLcExxR2tU05h1A5T8dKmXSxwbQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.14";
        hash = "sha512-2FlxzE/RPJEWehV1ZFMupXhRd7zO5iwAeRr0PSAh9ekncJXq/NzwxOCO1x3FZAQ219xiyNTWZw7zTKzq/u8XiA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.14";
        hash = "sha512-u6Q0rFys+js5kqXKFYjt3r9luWz6mtlPSxWaXwHZGZx0eIIBwgf3SVVvCl3/KeW1cQpBkcJLSbaxFUeGU2jmAw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.14";
        hash = "sha512-NQWycETvn24RMbAAVdzHzz3iZFv4mykfDN7e0mEZiqEbnW5iOh52cjoXpRvRdjJyZAveJ2a/kQTdzSAnItEAJg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.14";
        hash = "sha512-44hiqu+cEG4NccE+EzBOFir2DKyQ3gOC7cLVwP8VinuNrQRd77OIfalXgkO5iEBnMRbY2hFy76VEAH74qg75/g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.14";
        hash = "sha512-uL9+7x6c9QfLqiDfKYI4j9Wo7OoiqnuTlPCUEnmkvNgNhu6oJ6Oxwi5Pe8ZmcvSQ0Ro3hMbsSgcsrCSuj5ik/Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.14";
        hash = "sha512-qMxM6YNZq0JIh6Vci7Gv+B7xaC7np4RoQSBvVr2v2nFFTrniJuyrBa+SGvyneUbPq7Ed4Y4hPlOIWFIzpaUqzA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.14";
        hash = "sha512-aEssWrrvGmUani9EoDXWA4EdAElTtUlYxGvr2tYeIH5sYoWZQUB79C+Y5OuZoM78wr10j8qDs5IYBt7UWcV0Mw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.14";
        hash = "sha512-OKndBipAQ4NQJeZ3ZkmU/QPyRUR8K1haUQDz7WA7YBRCbWKB9HYjLLKt4gKJtsT/DmpZccpOUfl6FMKTGH5tCw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.14";
        hash = "sha512-EjnsSr/CNvvGZMPGRbwkYuCH4bcP6Gx/xrex1wCGncGwytU28K/5ukWktNp4yRcHTqHkTFmXVzKeZKQJk8tmcA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.14";
        hash = "sha512-GVRm64/BUwTNbE0Bxm6cyYnRGlzjuKcfOLV5cXvjJGGVtgyH2+d+0jX6VpSmH5HaBk9W/LYgk7Hy5jTFCFIgIw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.14";
        hash = "sha512-K0ODtP8Htc3l8dZ9fwmVPKCx9jxxowNM0xg9bTyvo7OreR03vqKEe4MMSx2zJME6s73goB4k3OpauGJeSJIeOw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.14";
        hash = "sha512-2/TpOJVsnb7qJyQYZzsm2gtlZfHNGCTw4ZfqtdrzQBgD05CRym1gpk+vABIRuLummvRNxBR1nCjPFKfJvSbKTQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.14";
        hash = "sha512-Mt7rKMKzhXahi/h+h0ACgp6rrSC5AdP4UWOoLFhKKOT3o89f/YMA9WDPdw/9Mtp6K3xBdTA58K7GNuRombQN6A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.14";
        hash = "sha512-JcRtyEsASNBQG84QDvJHpwVv10ec8O6pwsoLltWXYN31aoIFn34LEL81DT3/5eKCkMZwFzM1xywlzX9nDixDPg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.14";
        hash = "sha512-QBFT4LaNOnARh3rg6yB1iGktuQ5sgPeYMtrTQLEYRPFhp7cZPSmJ9zwsB18I+UE+uuhtOusNsR4DjHLjLki7RA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.14";
        hash = "sha512-dhhL+6wHQYecYgbwiLK/S7NHE2wh6ivd7L1IR+GHmP4N7wNA8S8pxDbM4933Y8X/CTGyNLIU5YAnWB9omYqZmA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.14";
        hash = "sha512-+2Gr6eXSLt1+5MNbtSLwgg7KBq6Jrjqbp7+tEkRvHJDURI7fZZMv3TB2Ux0dSYi4McXnEZ4XY4DW4hpY2O32BA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.14";
        hash = "sha512-QHp/N5r8NaslSYcDfOSOcTYR3/gepr0OdXqR9D4GE0IYSjI/RyiX8LAezGiIWODHY2n1Z5HgbTNs2mqRLuKI3A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.14";
        hash = "sha512-Yyp1Zk/U+cazP4MucjE5rZVf+8MNdv7XZiJGZKEtJyIqOCFhhToiZuvMLPFk4PHuduKLyGEpGCQKI1ec+8Ao5A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.14";
        hash = "sha512-fr+b0nrs26MU8FadCdjYBL6PZuwOw6cgeYMrV5LmJsBbQ5ENntMODYTmXI6WcKGug3hKnfMl77A5dJt5jLoGgw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.14";
        hash = "sha512-RbDgUBV/nywvewQHGuC/DPFmtTSkSkcbe9ZvqW9KTyrNmaJcR5Xqi/+tD8P8N5rlKgtuwABJOLE+vHng5t2bJw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.14";
        hash = "sha512-LmrDJoFWBow55Riz3isaPJ732dpchSwMpLqerY5oviq5S/AEAVozlyBBk6s7q4RULcgz0NvJVoPHtRp89/Nplw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.14";
        hash = "sha512-uYQFhRmzV4zpDi/avDnvp8UagkbME+2Yvx+rTuzhG8/lNds9a/j2zqaJxCa/JCSOoUs4CW6ZWoTrkELgrt3fCg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.14";
        hash = "sha512-TbKgoWwSO2WUnl5yIwcmgj3y3Yz7+ZtWEjsF3b9OsMDY3cjzF/gOpIL8tqwdylVe+mzgW2XWPmD8BjL5qWycwA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.14";
        hash = "sha512-VrmBNMU5hsPkQ9DNdqJZ4kZAwF+f3byFM7buUtI+SsFvR5oG2On0OZVCvEp7i0Yrk7jvP78jJLTEokhFN6SSdg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.14";
        hash = "sha512-zlny67SFPuSMLoWVv3kpngYCCfQ8sJb2dRjxyyItmbw8NQiKgIJnU9wT0N24VwMxJCQktlYBdOP0Gch5oSBaqg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.14";
        hash = "sha512-b60G3rqNh0pk+gf2ak5ljYjkjHN3/J4YhhgbEZbbIBcjp2vpdUOPbI/L1xh1VtQN4YmjTpcMEb+e+/DeU49BiA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.14";
        hash = "sha512-gfi6kfkLNParYwUH8r00IQEGylbeY8llXfT041rH7211jYTxoRmgjBihu4inAEhBwTsHFXztff9yMJE3rUdWsw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.14";
        hash = "sha512-v1NnoxlDAsrrtEfCG5LTGQ9ZTX2I7ppNyX5uUQXgcl5tXXnFDpy/EE/WjHtWQJRd3xp05O2ggKtEDJo7Jm8SAg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.14";
        hash = "sha512-la9B4zSYODRaAMPxMtYNH1f6u6TqNC4Xy7NJWflAxBH4AEXajkxLqr9PK8AppSuMYhpos6zt8iqq+KfpTgXvZg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.14";
        hash = "sha512-fB0TUW2CU5D7i/w0iB2D4NJQnxj19CwBx8PRag8y7w9C61RMfug+njo0xulzvNZeH04uzIbuQuNp3tpRKmQn6Q==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.14";
        hash = "sha512-CIaRnasFox5kHq/E5262rehitp6H5Oy+gQsq+0ijk0qToDn54AlGlppWyXE76WgAuxJhqW0yUGs/sK3K/KET6g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.14";
        hash = "sha512-utSA/7KRJiWA2vMEMRtuc964d8t44lf2QWeF/9mFC+7uun4qMq9YdBPi+oUJ9pDRXcHcLuZxaYh+7ZeBz/gLJg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.14";
        hash = "sha512-d6uXd6srcyZ5JvqeuxBfEFe+go+u4LnvHnrWq97irDFb60UNoe3Yav489sKozVFdVnsscNRTRRTTvil/7gkwhw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.14";
        hash = "sha512-aRc1YhjUgt0bVC2yTZaUJOgTw52/e0nxNlEJwxGn5hNaVwGzVrHi+W74siGImRQgMnuwQSsG4YSAyQXpwx1ufQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.14";
        hash = "sha512-AP0qvwZug2ADN9Sh9NG7/BcBvYC7bHTuTI0onEBBN66N9VdnOotJ2CVrysqB1fwCjEpKonKjFG4TnusgpI7ksw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.14";
        hash = "sha512-eIWQq44SnsYJ1oXYcBi4lxegwL+EWCGDdp2I92nsKGPf0YJA4BzeWQH5ovufnbggm1YRtRa2tZOhCQu5zy+1qA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.14";
        hash = "sha512-sUueoH9vKyt8nsyWGAdQMWCKpu/NcFYbysSzkI/IbMQqi8DP3reEHrrUNrMJ+nfu9rEpeMVBvL/xLpEpWZTq2A==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.14";
        hash = "sha512-i56Ojjg07PJjYCD+DPI5OYQwvnZ9Umvj1FDqH1LMyrlLEPq4XrXtpMgw8OPGBqrDlimxdiBfYTNfHuAQTPOvfg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.14";
        hash = "sha512-XhwpOMwc+0Is4Z9+mpnqiw+d7WQYvnRVEcYcR0wBfXnv0uzWfqla780WJpGz3poangeAbI26+DN62iu5S2Uf9A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.14";
        hash = "sha512-vn6R6iMz7/xqUdmRBsBYz6e3FRKrbHl2QEOjAOZ0OEEPOHzz+dBwFrCdyHCdseiAQJz91vgP4kCG7/qboGbRlQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.14";
        hash = "sha512-eb+B+l/xhkd1plaUM2B3dFBawZGN+gyMofPEgPCcIeRytbM80wtnVlDoa6nQuJegnL1q57n8bjT+p5JYW+DAxQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.14";
        hash = "sha512-0uvTv8AAZzBr7H5+N/5FxQ5M4xD3inQQcVYQf/mX86dp0o5RQleCWZAwXAwiRTn4L56DVEY7Kr6rFAn4yvHXJw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.14";
        hash = "sha512-7XXhF6/mzm/2Ytupmh31rtMXYZxvnRcbbNFjYGU87CAJiwjdPRmq4c4tMtRe6bXHvtRXVYrNXKLKVeBIs1thww==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.14";
        hash = "sha512-hZzHghZ/bfEWWLDO72EFgnDqdaJawOvMeSS7zX63kXIBvj94jIsix/GCwfFpILnGy0nMbwnnt59iXedRptU40w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.14";
        hash = "sha512-vd+jJiEMJD5VM4En93ZDoewHu0eVoqnLFXP7xQx2BKLjhvViJKQBOjCFu2L8Holt6SneZZxMipwUfNfxFpjY2Q==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.14";
        hash = "sha512-sksqJ2OBKIkDQ3iITJoIVCfTSYgRrSc+vCGvXqwq7Bqh3UR63TeeDbpKfeooN2Pb/VOxrZWiDS0+45ZWFDbL7A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.14";
        hash = "sha512-rV0jSmylGjPRFNMFForGvk09iDkbEnDoshc/gT9XM7O+ObKj53RRQ/95+kKekRx466a6qy9dVRMk8J7UzLZUVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.14";
        hash = "sha512-o7TudT+DUT3VNCtz/PUBdWHcqLqQ9Vn0P+9wYLNZvLHhQZObfPgtUEnlTC31U/8jQIZou9h0h6orWtPy0Rp0pw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.14";
        hash = "sha512-4sGe+yG1Z71AEyqAxOLjRLqrXctEUtqmMb2Zv3d3ujonYk5lBR9K2M/nMnEaXgKW5OAKuxwB8q3KVL+yI3qgfQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.14";
        hash = "sha512-rO2v2keP9iKF+o87Vw8Ch9OiP9d5RhEDqiDy2Dlu9Gcrvev5EpFfmVrxc/Meyv/xS2kzqJG4wRP7oXg8wPGIuQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.14";
        hash = "sha512-lvLGXYrDY25aBwvI8RqTN/I8vGDC5pw+v2fCXoA9wgtsPXgaxzb/mYZojwmDwRHTm7N2BWXdd/fRVa90YkDMkA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.14";
        hash = "sha512-PnHB6vviwkg64h/aNWoak5gMWOPjVpEyT9S4qzPxw4dbh27pqfYclB3oj7HEBAG+PquRH7I/nozeyE0ZXl5jDg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.14";
        hash = "sha512-BceK5BaK2mHRJFTWPrLZ7xBD21PnDrQr74mlm9Eiz17Ka0tQ0aYVCbNY4XTpILlsJ2FNLNEWlVBMIz4yk5JCkQ==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.14";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.14";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8e39953f-874d-4d34-a41d-2f0f761d9657/0ecb320781f83fb3a94620e1dae6fe27/aspnetcore-runtime-8.0.14-linux-arm.tar.gz";
        hash = "sha512-F5QB2N4T4g5OefzMKdYEdm5S1cFzKQrvE5nkGZuyfyn2bF7ky6ssH0RoCNQPyvk/tBagQ2i2OHdBZWBT5AUl8A==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c7cf0f96-e75f-4376-9f4b-fb10b2129d0b/a0eeda2100a9fd1858b95c8d9267fa51/aspnetcore-runtime-8.0.14-linux-arm64.tar.gz";
        hash = "sha512-ZMIkfKhMzhNSXlTi6wYsol1/hDW1RUNEKxFnOQbumYsUcyGucgkg3rjtlvZsHukXx76puQs2AQjgRThOjaRJIw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b901af61-a4e5-41db-9402-f6a035bf3ffc/af3e800d44ced22133fd88f8b7bc4ac0/aspnetcore-runtime-8.0.14-linux-x64.tar.gz";
        hash = "sha512-uM0GQMKnOCMwtEvjEwMn/wA2voe2IPm4rluFT840a2BYbde7pqaE17BR3JNAJRcMuUXEHqO8khFbMOZ+7q+5IA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9a764ede-3005-4614-b89c-596c4edd9817/c0d09b9f210a508b88f060761bc7e055/aspnetcore-runtime-8.0.14-linux-musl-arm.tar.gz";
        hash = "sha512-5PhLcHLHDo52qM7uCg5N/3ueRsqg7k6TiC0VwL/w5Vg94W4YHCaIC+zs4ASAeF31eZaCAo15CKs/KmlKoxRWlA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6051d61d-3546-43c3-a3a5-891b057dd240/59190faa572d9d8e6140e59b4da88787/aspnetcore-runtime-8.0.14-linux-musl-arm64.tar.gz";
        hash = "sha512-28bb1LuuYTe7COEV3SrWdcU3PD1XMCPO8LvcBQAOTK3y8xuMRCWuCGvhcSocuyFb+yrRnNTmXEsT5OoI8ECNcw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5de0c7c1-feed-4f36-9207-fe89719ea60d/6504c97a7a7ef10c9966216e1ba2eeac/aspnetcore-runtime-8.0.14-linux-musl-x64.tar.gz";
        hash = "sha512-bhvg4xBpFP6G3cfrfHUxv3lDXttEwpO1shdQicFlncL50xPOID4E8Et4Sf61RNQ1aMdOrh9+gB2snXQtk7fG3w==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f9e2d7a3-eb31-4caa-a9b3-df82114818be/05f85cfb2520e3f3a69ecb399d4533f6/aspnetcore-runtime-8.0.14-osx-arm64.tar.gz";
        hash = "sha512-4xHB/BJ52kjjTteNsNWyl9BcpbHM6lcCpY+GJKljMnRptVuhkuWE/xo2BWgm06nlUIV6ZOnVVhbVyR7YEedLZg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/04d7eaa1-cc07-4462-96fc-e0773f598da9/5936bc22cd233400d9d9244ecffb6b56/aspnetcore-runtime-8.0.14-osx-x64.tar.gz";
        hash = "sha512-7We7cSuXEdCJE/xIIwi5MER47bvIUp8IsW06SWSqG1rb88EZu809IVU7jwR02Q5kODBlM+kxbYVfX+9iy7kkHw==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.14";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c3eae65b-60c5-4f4c-b466-e2671fa9e044/ca57cc875f7991917e6542fa404e94a9/dotnet-runtime-8.0.14-linux-arm.tar.gz";
        hash = "sha512-a7sO9NiFfrub2XEPzpha9h7wSUrnlJ7CsB2JUbFTBry57E6ORerYATgo36kuk5TWvrAa1fxMauKj+5kWR2sWYQ==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0e0083e7-0829-4d6b-ae47-6954508bb545/47c8c96704206348f8aced67d9f5552b/dotnet-runtime-8.0.14-linux-arm64.tar.gz";
        hash = "sha512-UZttCmE7GtP3bNgxbCnc9KlPYF42hf+pecxjKzJmbMmzegioSo+bItuovWMRLlxlOGzkt1qPjfUMUow6GjlSlQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a52595b3-f025-4bcd-a3fe-b6091e276d76/4c0d27fd34b79bf7c21ba401b84c76e4/dotnet-runtime-8.0.14-linux-x64.tar.gz";
        hash = "sha512-W3xzAN0wCEZQoiZbZhjzZvCZ3/KykkguXgXxTzoLCFDGWOzzg2g+Hc5OdTphb9LjwWnBc0pnmvzEwMrUiLn4oA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b88a6ecc-0c4b-4a7d-8132-f8721d61894b/0d3709409cc78b35be63a2f1af83d71b/dotnet-runtime-8.0.14-linux-musl-arm.tar.gz";
        hash = "sha512-TwcbjlPIBGA3vclFyN1hlV3wdIIOjnvDkiqX/hvMlXRjXJoKq2Q9XU1biSjeEtFENb1usJfBib2FDU9wTbva3A==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4017f053-7dfe-482b-a7d8-7302765e1753/61b9df3ac4ca545508eec68556c4ee1b/dotnet-runtime-8.0.14-linux-musl-arm64.tar.gz";
        hash = "sha512-tCi21UQUr1FHu2qAb5eJRVQLGts2pdQy2U3t63mOLP+iec3zJ6VGQ1d0O1JnAEh6735rEYzuzZ1LYjQAsErl2w==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3bd37eef-8186-4ffb-bd71-5385d93463c6/76615b9cbf7057ab7a57dc661c28a4f4/dotnet-runtime-8.0.14-linux-musl-x64.tar.gz";
        hash = "sha512-+d31mYTqlpKmJMoeevJ4NpPFZJeer0YN1PuztyBw+q2h7jaiCJXEksiG8GGr8Nu4MnsfjgWBy+SZFmbwkrCXiQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/20e4640c-f87c-4371-97e2-68937dacd3f7/7a0ed049cb85070c9babb409cd0106f5/dotnet-runtime-8.0.14-osx-arm64.tar.gz";
        hash = "sha512-mpd5c/BPNdXWNCQBdL7tOl63gh6QVCIknulJcrlpSCUoQ2IHgladn4hrd9fWqz809VXRHFGxEz5EN8A5jBQkDw==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/521020c8-7a44-4b39-b34d-8c82b1b8a5b0/d5e9928ff69dcc6b2c491fc87853109f/dotnet-runtime-8.0.14-osx-x64.tar.gz";
        hash = "sha512-EQ3cJzWWdwseY4p7JGS0nGq+m7zBJB5ER8lJuh2a/gHpVk2d50hSgbXeLGwidG1hVtIZMzK40hK/+kLbulToMQ==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.407";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fa0b945d-9b0b-4997-9078-62f29add55fb/d147deebe6632cd7d9c4dba8a59c525d/dotnet-sdk-8.0.407-linux-arm.tar.gz";
        hash = "sha512-SMNbsTzIS466CWhVSDIQLxkOlOmsPhT2bFgUlt6gag1/i1b8A31XFuBCUPJUMW41v8EDXze+2/f/xc+HJ4MzSg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b24d4004-0073-4edd-9993-92fa5964eb94/2db4e2aee247349677597657d1ac467d/dotnet-sdk-8.0.407-linux-arm64.tar.gz";
        hash = "sha512-fZi7U2yJnebFYSsFQ97zp2yaJPWaD8KzJnHh6YBjxv4X/nCv47ruOPB00LR+7Vd+mJ1tB/Qfd2AmeLTt3d7aCw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9d07577e-f7bc-4d60-838d-f79c50b5c11a/459ef339396783db369e0432d6dc3d7e/dotnet-sdk-8.0.407-linux-x64.tar.gz";
        hash = "sha512-62IVPsyeU6VCL/RPHGlmqJ7kQqkfd56XGqpHrWpmuxMa+bOOTKASVnVHuTV7crBHa3fStzmaOKkiSo5soCqBVQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/172bbcd2-e565-4450-b321-bb53a461c8c4/f70be49b4c0793de7a432db2c4e8b597/dotnet-sdk-8.0.407-linux-musl-arm.tar.gz";
        hash = "sha512-pBa9wZSWwah4L7HLyWh/o5qWq6VuN8AFwbC01AGeQWeikt7xWus7ZcJR0X7BJr8adzeYkdQXl3owLDAGFAwZKg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/06f9f71f-1dea-4ab2-bc97-a718696e9981/e7e0d054b5c8f414b2e8284698877a85/dotnet-sdk-8.0.407-linux-musl-arm64.tar.gz";
        hash = "sha512-3sxQEJlMvhTxQIn/LgFJJwC3IP1LTf3/VLoRlVsZN3WzknDauzEOKQp8Nx4vKXihAkEGeRHf0OfWe2mabM41WQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/90b0107a-bd0f-4150-90b5-f02fbe4967fa/eb6d17f541646c866fb1887631462820/dotnet-sdk-8.0.407-linux-musl-x64.tar.gz";
        hash = "sha512-odW2YPn0P6m4PDws/lSzf3S49ObIoArG8P0yA4WOgvPm8m2YzajunJxSNHjbMmCEjuuq0VsoaUsjodSSZjspnA==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/498ba09f-6b60-42a2-9806-7b548ab9d9a0/9108cb5aace61efe4c9bdb33232e7daf/dotnet-sdk-8.0.407-osx-arm64.tar.gz";
        hash = "sha512-HgyN6+NI5+bcP7dHIH6UtbjFJsm61otEZUSbjHvCqyJZzwREr7OUZgmUf5YLKXKc5Yqwe0qJq9uFwDvqw7mdvw==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/dc1f1ed9-b254-4d4f-bd00-2f598cbe4222/ff4f618ff75630a971b119d1d179fed7/dotnet-sdk-8.0.407-osx-x64.tar.gz";
        hash = "sha512-aRWTXPA3ulgKq3XwXsuDrrIyIYaQlgjr8rhxPVvxGIM6xuDgju4HWk3EDd9fuIYyUel3mQbbMd5vPBS0GJH1BQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.310";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/71352a1e-a3a0-4166-8bfb-7da568f1ae1e/2c97e2be425773e98e9b901eee08fcc5/dotnet-sdk-8.0.310-linux-arm.tar.gz";
        hash = "sha512-tRK1PtlNIShGSRAK1IsAdb4AEKxPpzArvsD4AuPUc1kLTcJb3sKygsYTs8PNtuhMseskEb52YTiPwFHwYQ+OWg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a38ed9fb-22ce-46fa-a0f5-d79e9e0527fe/ccce056b49040f162445a2218010162a/dotnet-sdk-8.0.310-linux-arm64.tar.gz";
        hash = "sha512-2At0xphq8g3P6jnap3MoY8lxiSjSGrbq2nTD8WKePqqtmO9I8ToOlprho141UzXjtGaF9eVnlFRXAxLjy00+YA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/cd4548fe-6343-4e04-9e75-1a5f4d05cb28/cc7ea3e1cf2674a9c737b9b7c6957e4b/dotnet-sdk-8.0.310-linux-x64.tar.gz";
        hash = "sha512-OaXhTl0WES+OhlvaiCKfMvaIWPgCIhMn0FfLyUHLsIIiGIXg213VALOZqR9INHYLW0/jvcjr0DRqJCm94UJSzQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0358843a-7c5e-4c77-9b03-454aebe0e587/42e7d1266fe00d3931978d6333fd49c3/dotnet-sdk-8.0.310-linux-musl-arm.tar.gz";
        hash = "sha512-FmDxLA//ttr6TBgvMZCg2FMQy05CNoNnHnOFS364ypZIWQ1j5kf3+StI+mPL1s3/S8p3Lo74n3cQhUaX3RVEdg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/611a6103-f9ef-4f6d-84bf-a39ba2a4fffe/ad1b2c86159f8e729710625c1380e9f9/dotnet-sdk-8.0.310-linux-musl-arm64.tar.gz";
        hash = "sha512-D1l22bTZ8G4Qxfou1We3LFOncC4UbMamFguOXpw0BDo+Qw7atL0HUOoLkTkDGohQ76eQJ3Jx4X0SHvGNHAGFcg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a8f29f5a-c004-47f4-afbd-bc6ea18815bf/8ee826a925199a3dfee871ffc5967b87/dotnet-sdk-8.0.310-linux-musl-x64.tar.gz";
        hash = "sha512-J3kQGSdBzSBk0CFluOlskP/6KCiqrnMQGR+bxXXP/5eU4Wd9waO21e87NlPeyNClR8vMV6Pz0NtBWRMGtHX7aw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/357d11a5-9826-45f5-ab7b-edfa85c55680/3a30aabac2327935e5d0476f625d7145/dotnet-sdk-8.0.310-osx-arm64.tar.gz";
        hash = "sha512-rLheK/m8zlS5eGr4PaEIPbJpOMLF/pUALF57LPNlPR3w2C2Ujcm09AYuE0waRpHF2PctecQl/tyF72awuWgW6A==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3b7b4f45-2aeb-4c10-955e-6d982d247e6b/525bcfbde20e4593d7bc594ec0625386/dotnet-sdk-8.0.310-osx-x64.tar.gz";
        hash = "sha512-Hywp14OnJAO9N7mXCSd5wR3dnPSJFUD6vZPWVo+LmNowTRUA1/9tJQ6WtyJfaTuahyw+hLROs7Gyj+09m5nPbw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.114";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/453bbcc5-ef26-41a6-8403-fb99df41967f/30d5b7c86194120a07f06648ff1b7f07/dotnet-sdk-8.0.114-linux-arm.tar.gz";
        hash = "sha512-PuFH16rv/2DIBUu9RXU27X0EilJEAJdVPD4J5K3c8VQRKTjd7jIiqqhxmUM7JoLih62fZu6AsFPHh2BmhfAKbQ==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a3897862-f00f-444e-9481-f29be3fe659d/af3fa901741428a9c313bf1e6228e331/dotnet-sdk-8.0.114-linux-arm64.tar.gz";
        hash = "sha512-NADfod1gFgyEFEMLYM0qFfVdlWVAzeGrYzgQoM3LVCOl5g4hSCJEP5S6B3d5umBsuPXeb23kkhkC1sbMkhK1VQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/10e08991-55ed-4dc9-bd12-9cfcf0339ce3/a7741b1daf778ad47d23d49005d8943a/dotnet-sdk-8.0.114-linux-x64.tar.gz";
        hash = "sha512-K7sWZwtsr6HXTfPre0/uobS+yvAKaQ2Brkjknm10IdtmDbjaQrgvFVGaRYOt4PDl4veOx9y86m8b6mW/b340tw==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f3ec51aa-e1b8-46bb-9985-c0bd38621c7b/a99f10edc0159e8a0786ccad88d10aa8/dotnet-sdk-8.0.114-linux-musl-arm.tar.gz";
        hash = "sha512-25rJV8PkZ2Hu6gtnCujaNmhR3s4lq/SY9e4ssXJy5bp3tsJ//Yh0O5TmDQ1jb6z5qy1Io8SrCljAGq3b2dYWiA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/10c607da-0f3d-4bb2-b4a0-a9c527af3f2a/698bd6321bd97e5341216c7c55716211/dotnet-sdk-8.0.114-linux-musl-arm64.tar.gz";
        hash = "sha512-XT9GEcxfpqcIM3lwDHQGXGlfO5K/724JJkdZP72OFhnV46SIHBujDbY3Nj78/pxG7elEjONf3iLP/4q8+TuvtA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d9d512c3-56ad-447a-8faa-fa88f610d0d1/8a0903b787f23367bcda7117e40d81e2/dotnet-sdk-8.0.114-linux-musl-x64.tar.gz";
        hash = "sha512-ZZbCYBvGb8xM+tCpNc6Vk67FGj7CzbyzqxqyHlGZP5eWSnO8Ls2P5828j1VKSE6OkgnwUEtvrAfxn7kXE1HI5A==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0d2377b6-74e6-4436-b1fb-17f0164647bd/24ac4b3ba73854a076fbb0f99d950ffc/dotnet-sdk-8.0.114-osx-arm64.tar.gz";
        hash = "sha512-VRYf5miw0ogyBrt0zk0yydcBnOG/xmRMGAK1PZh3TmP1hoehpfd7Wd/dvtDCS5g5CHrFoNlYUHzYs8ZO+Xw0FQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/24801e69-6505-46c5-a0fc-b45c0a61f939/8e62bcf58dc67014684e15c0cf03ce0e/dotnet-sdk-8.0.114-osx-x64.tar.gz";
        hash = "sha512-2WwKQwCHvbJPLBQvJnONvxsyNlViLoL8azTDnbGTzSEMC204GJ/ZussMTamA8xant0ClTOERJndShMttuaPGJw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
