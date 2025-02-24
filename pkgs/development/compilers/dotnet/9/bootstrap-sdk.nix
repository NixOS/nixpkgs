{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.1";
      hash = "sha512-j59whFHFna8m2rgyONETv2AyVTcGgNYhynz7sljGIQI9UejOz4lMtoF6ETztgdKcxLM/PQpe3iXrc/1s6cL6uw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.1";
      hash = "sha512-MWBkM9EBf2IXGLRhtwOOXm9h/adAUyEoYEjyxvwDPJbBLX/aWCCvEzKRH3AR3WqxSCIuXMy6ylte86SiPuU2yA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.1";
      hash = "sha512-yGd0EFC4wluxps8taqReKJk5fsmSf6k6SuqUnnwrw6UNtvUtJqWLiIThkzl4g2I5ECxqt+ttnN3iKnvxoSKc6A==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.1";
      hash = "sha512-IqKgv7kZ6BG8s31dCHqBgLuP96YHHSUvndDw1gCSkZ4kwtxuo4/gIonNuz9Y2BxJFVyWPpSDjNIwbOBgpUrnFg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.1";
      hash = "sha512-w3hS2Z0dQpqktohyL76mSk1qKnP1CTHYg0n6LzlP8DVoCGyDW0GKOPYM6PWzgmsv62PV0spUJtdiJZxAPmF0FA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.1";
        hash = "sha512-ITqGyFkabgmC8HDqEvKTy1T6eAI5Jzt+FQibZqD7mXx3HezY+Vug35QIhKoZsGvBgGZePXXlXGbQXojv24oBRQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.1";
        hash = "sha512-pJjbOtu4hjHVLu+ohoe3HW7z7D/VDlpnO8gCSZetd/DStLhBkgHx9Ne0bida9+UADDqk657d6tBNlKmk53Xe3g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.1";
        hash = "sha512-58uQG/MEDkL5KtUGOcyAbXQwPM2hguHALO2GzrRolb/G9cZBWxPdzsz/Znac44IXjPr8ELq+L1Tdj4DOYabrgg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.1";
        hash = "sha512-szJlHztrwdlPp3rRxcvKPuV7XUYHbYW4QOf53Md2bfz5hSZu1O/fH/Md516vGD13NXykF1sK8/+YlI/Zg1flPA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.1";
        hash = "sha512-9qpCPG+jgL3DG8KUycZFef6bC1Kayo1IP+h9syZYdrcLXDmbZTJu3hcAL4S94O/fSx7kNCJNfZ1IiPFc5OfafQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.1";
        hash = "sha512-L5D1Q+sTwN0cqr7yMFHJVialh+G9sbZYaOOQP9eBa1/rWxn/FUAGbPSDpKJTyILFPu1aiykYk+7zvBzyWUxXJQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.1";
        hash = "sha512-4re15jU1KkriWUfIzAvl/JgRWqNPIdoP5V9tbX2SW7+xJo/UQ4IQkJ4W9Ct33e8gmv74kqpOaUAW8Ufc3AEvZg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.1";
        hash = "sha512-iFr8JbqjJuAX/358K6rVsnSxLtOi/fHufP5tDypK9OpUHeExhRw7stDKfDaZRccGfVIu3h4WG/hFzEnkAipEWQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.1";
        hash = "sha512-BGXpmXcXPRylzaWOrojpjwa0TNPU1keLVptsJ4F4Pbd6eD0vW7aG+tIWhRDmj1hn0u2lXWpQhdUHuE9kzQokuw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.1";
        hash = "sha512-ZO/XMhmqlAlcFVk7LFK6X3Zw1309qMD9CQtBH0lJWqcKCoCJ/M/kR3MFC3LPehH+tmRGeiLOzTdJoXzUDQlesA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.1";
        hash = "sha512-j38WbOTxvqiOycqA+UkCdoOmAGNleiSmoaYbmR0vx8Gt/jiQ0dWUP272r4kOfytFsPvXDSq/8BClx6d5auUjbg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.1";
        hash = "sha512-cXNoNxA8DEwlf7r7slfLqnecqmuEkKntXwrG937SL3fEeazGsImV0dVr46k13dbIA56NyBS3vQ9DuxtqnDy2Sg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.1";
        hash = "sha512-CMu+1kW/TMcHSe9tmM9JKPm3BPr8fE81qv5shG0EOcovBu8Z2FB4x4cj7tdQIZjC/M+yxfL09lmO2joO06mLZQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.1";
        hash = "sha512-lw1vFGvva0T6DYbI3258wS8Aw9qHDzDR+hxaWwAJUVxPGGa5aDSeFfZ/hP2qtdn17cnlUEhCR28S2rimkJnc5A==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.1";
        hash = "sha512-Bcm+qKreOBnsaTPZA8Tf0OPKnFLdaeDmNLjgNEdQptMH4s7s6RJkSzTK24brSKTsGJWD3ku76415Jt+cHAUl3g==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.1";
        hash = "sha512-BJJsB434xCwvhwoBc0yS8bqoO9goLqGeoAHuSOqCC5hDNhheI52cX065vZ7dwH8gtNLXp1MLsOs8/vXD45NaNw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.1";
        hash = "sha512-Z3ZAGYzDjE9Q/D4YRmhfTjEMsrCb88l3PEfOQmnptmmjxWxpNJTJuVldhPy5caKbviw1iSje2dvjwLQ92+0zNg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.1";
        hash = "sha512-WLYp1Nf/K8SSTK/TF+O70LkHkrk+S5KU3WwforX2QAlN9Xa6zscHSbiRulvVNLbdrb5Bx/8xcsps2DzbuJgeoQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.1";
        hash = "sha512-qPEOgS79oAsERd8UydEo2MHY1Waiez+XdHnUSrBCHoSL8qTwlurXtDyLkGLKPqQkkWNlKBx3jGXFAewYThzifQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.1";
        hash = "sha512-fyD5GczwLT7IhFnWup+0Mh/2RZtO7lHrA/NMB4QFkn77R3vIS+aOcWaoS6Pk/3X7K+71L6z0WP4+4IsN6ayn1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.1";
        hash = "sha512-99Pkg2wyoEdNxQwn9h8VEtMxmYid1ieI2+dv3uzO4XtHN71H+mR98HMAlXFD8eBaFXm0FCIFCjrDC+OLAiiElg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.1";
        hash = "sha512-/nTipuxWKqvQkgSM5IB/yIWQ0OyRmQUdZM5JTaK0SJ6ZnbLiNlWHo2INZE/8syLhHjc3JXCzY0Zqh0Wd8+dHTA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.1";
        hash = "sha512-vjgEIRRMOnS1BU0v4EB+ljQaiiRdwDG8Mt9vLfWti61mzQPuSI9UuZSVEQAhGUOZBazBrgEFi3L2/VcLKym4Gg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.1";
        hash = "sha512-CLzfEJ20LhF2QEx3Oa/p4G3kSE17OEWZ5s5yKP3voW8sw/+MoMk5Y8R57O+jSyn3ZMfauoVPB8TIcOlrl/3+kQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.1";
        hash = "sha512-rGQNTsy0aS0TTAko2m1cWUwxsbKJKUMD3u2qO+3K/QlepA+gFBylCfijENB8SaTOCwyPwI6PUiSOBlPdaPbo5A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.1";
        hash = "sha512-SMApYm/3kuQbxNDwyy7BvY9SkusCm6Iwu4wPPX7fKnQ/GyGwNeABJIqq15nAwJSZR1EKAlQe8amrXpgmrkrrig==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.1";
        hash = "sha512-UFntJ1OeRdixs4nmhMxLcyXfwjmNew5EkmbquA9UKI4kKViEZEYWOPLPOYTGGhdfUJGRHbkXqIrsGAglFeLyog==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.1";
        hash = "sha512-NMon6hn1ZcNwqv76Y3kPuOGhcR/l/dH1JcT1bN/qrtNIvtEPMmaSpnUXVA9/AazVGwNitsRbVI9uZ0CfWm9sjg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.1";
        hash = "sha512-IqVXfM1Iwip/V8Xy4/xvGbz/Uvp/We05Mt1V9WLD1pcEVFU7Lm5KRFN3+NckqhnHAgbENEjQWiqcII/0pKWvPw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.1";
        hash = "sha512-4lprzdBSYv2uvTFcYuVddGmzkqDsgCIuzOusJ2HFowxHJt3mdNS+9fbFKTMUGYxTeysQpNdyd5pTEYnswnaTug==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.1";
        hash = "sha512-el5p+CAqxwjmvRajBNgWiQKwLDfqZq6zT4CPaoD/9zOhJhsXrR066vXzCE0FrVyP8QYj1iJlet3+oBNKoaW4lw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.1";
        hash = "sha512-bB55+r+vjLwYcO0mAj/NgvfVvn5k338nJ41qIJUcMrnBLymZMhPKNmMDlxSrraNVqflhmzwBGX3mlk99YUssXQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.1";
        hash = "sha512-dXGlvBXlEFhXtxslCQI64Ax8q6fWf/s+LsfrhNzbgmH1EJdhrtij1eLDU8+ByRiCQs4nNj9r08+2FKgDNRSEBg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.1";
        hash = "sha512-G25u4rIqRuf6PWUOq/QR4yBqoKT8yff/W8hQmJcVSCXCIudrmiqwdr8XGt9RVO/wpKNyq2TRsr/uz37P8lCfQg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.1";
        hash = "sha512-Q0DvC9HdZDWHw5j3OUPkC/0vD138RtCyrb1v59/09s+Nx9UziTyD9g1VCMV6ulRlJwVbNEM5cfOin9jnVa+aFw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.1";
        hash = "sha512-wif1X7iiUq2V1kwXmfZQgtHtG2GvST3W7U9bjGRApW1a4z7DX4SE0JMTqfaHdkBVroUh1M1o9tE6zX1gGkxOHQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.1";
        hash = "sha512-/6Q+UtzMeunuT01kjF3WXAG0U0wAZgEZqcEteomAGKBAYncTKXAnsslQk0GLlLxG7Cks0ZetOxARURNjF84ZpQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.1";
        hash = "sha512-xUDRlzgeLcyG52I652qzQc9QKlW3/LwzINgfMs223EYO+sIcI/vNJxdoC05s2NVby47Y3s/bXoNU1rMdfHfEIA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.1";
        hash = "sha512-4+AFlX4G0far0LT8WzuVjjsYEpWnyHn9G9yK/aulaB7coCeLG/RA552MnEITGwr6RiUwvgjPFHw4RmMvvLXlbg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.1";
        hash = "sha512-9co3xS3uaCXoMQuuyMSP77T4ACIjz5zjrflm/UMiVFjzvrmb6sSByHvZYO8DOPW14pnA4aRlCr4qhcoILliUmA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.1";
        hash = "sha512-aOewuGT2fyUyiRLgfCP8H5p35ixkIDbegEOxnAQc8NcCvh17SG7xZCk/I+8vELcXw6QTVoFNc1Z0f7OlSAImmQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.1";
        hash = "sha512-Y3K03HiKY4EAlTaBTCWhQkBMtupuxUabOcFsBWhwzYFVNwJDgmWeS8EBIMGK5DgxKvn2GtR6hLShucSNfgHE9A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.1";
        hash = "sha512-vUSFlMJBvIilcgSX0/lO/6oslEdVMeNpKXK8XRSQfaa3jfdAiosvN540E3Y87i700yT7T1r5qbEbW0v5P0dqUA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.1";
        hash = "sha512-rO0C4vvuGQI1fokFIG4W6u4uscFrtZiH+wBIcwB3oVp/8z5CHDUQ0mqfaxjKtQ0pWS1eBpt68ZvfRKK6giIiTw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.1";
        hash = "sha512-VbCfkSCgIZC/CSqe6SIbMbQ8OC/tFZbF/J7GTjwSenxEq3dZu7njH+CdyUcRoN+voxNSLXDc0PTH2icTX8sa1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.1";
        hash = "sha512-UWsVcwp7L/dKGN/E1YbiLhAzUare1IQc1NiOeKlB9XetS81MkSllasLViFG7TF1G4FNiy+bsh0G4JKE3PNXKrw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.1";
        hash = "sha512-yzF4l/m0FV+MDtQjlx0Y8MooG5AOINYuIWTd7hLuvhQlD5xcFQCVrf2+8d3JEwFXryxn9f4coMMxG55/kNoq4g==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.1";
        hash = "sha512-sIyKf2ll8Fva8UMzQhHowskA+xp6f9pA/X+wnWLWrdErrI//95niLTo3MgqCZQq25n9Jo811H9gG430tdOEvrg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.1";
        hash = "sha512-m3uywgan3uYgy2sQ/tZt3v5XsnFhoqGdb3IAu3vZn/AmTp6Mi24obM2We6N/HlJJ+U+M8+fb9fdxwRRg5De9cA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.1";
        hash = "sha512-QtjQWyB4NJLf/3WMXCl2D6NDXd7lBDt8jGkN+4lswz/jnBpIAyHkYVY01evcUOGK1/13QtCIQSkJjQaybXlI0w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.1";
        hash = "sha512-d1MDpDyn3Yc5ddPe2I7cgvrfUALxPZppiF6VhavkzybpEVq5RPPNdM5S8R/Rhq612H/Hl3C1dKmeraYjCQ0uNw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.1";
        hash = "sha512-N2LRmh6Iz4Gc9XmSiGOgTYZhHltLY8TUjFGfcykwAKu4Dx5dXuwru2zX+4I4AstYqGWACz6rlJDFIqrzEGIvbQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.1";
        hash = "sha512-WjdTpBYhgsDflMrvj8laO7tH/Y+UHzDm7FMlt75Oa8k+AunOqjpo8hLgs3ztQcPw+rvqRNe4HTHoswVSUJg7TA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.1";
        hash = "sha512-j4tValfWVEG+UhmS3NGs6nb0Gjwa1tJZjk4kFxaC5iCSXQSd8Qs+0DdH6bOiF5O4GQt9br2WJH8+UlE8S4YbCQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.1";
        hash = "sha512-WkYnRk7SmmU/iZRz+HEAtCHQWDz718HvEJ7zsrA1bNgA5TI4APWPe0xHnwb9uUmmE9BUyUvEtK+gRxYuA8kLww==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.1";
        hash = "sha512-yrQ8Mq4CdJ6MO5Pc/8PrlA5yU8XozxuXg4MCRbOIYcOWgJL/S6zW6t0rmspyAlJ3j2PS89NF5bwZyLogM6IZdQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.1";
        hash = "sha512-m4gtvFK+OpEDeL587Zb6KYddFrWrtb1z9yoG4ts1hU1mYytiZImZbcej8OMm13/eG09JTWFxfgxecJMcwAuhhw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.1";
        hash = "sha512-DZKhEHctFy4d9v2XCIm2tKYfirXNvcMTNf2KBpV1j7mnDAop+S+d9OJ8962JJKqkZFYeDHp5R32RqgI4PDfqsQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.1";
        hash = "sha512-NGny5Tp4IrpCIUUmt9kosbuFOxLuB/glkrZHvULR/2v1IeUstsW0lP56rds+PBtkN9DY603J6LbikmwUfC/Jyw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.1";
        hash = "sha512-JmmvPGzjAhPzt/OJfMqEOSPMCbFKjLSjI3JW+spalcj9R2kze2G3xR23TeTIppSY6M6UqHfYtEDLSRQ2mLjBdg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.1";
        hash = "sha512-K4s84fKknMNlenkFs0sSDoVV+m+tRxoZzXJ4QsqqoXYBF940T1Ryxf1Dv88vHmg4QUIEF6t4LeItQHQXQa5xZg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.1";
        hash = "sha512-/RZKZuUCUw/V0BTxfFU867msMi28ATMN15TS2AKOboZMFagDXCYaMYGX+IUNDzGxDF0m2B+uE8I+Eh5QHpdHYQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.1";
        hash = "sha512-/MFc3XgEWV3Wt14/f/qSEitWlbZSzbSJ3uki3ln35HZAlAae4roj1MuZWfW2DL+Dtx7957N34Jndx1nXAAeHvw==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.1";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.1";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/463fb01d-fcad-46bf-8e5f-0e568bb9ccf4/a3ac380fdc1e29ec25e5fa0a292a61df/aspnetcore-runtime-9.0.1-linux-arm.tar.gz";
        hash = "sha512-+nXY1a6ZreDRq5ABiDn+P13cTnt0YXFcrysL96iMjobh1PEKtpcD0jGLKJwHAIRuIVV0bXuxrOPS0S4XWrGL4Q==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2a193300-e0b1-4e9e-acc4-a4a695c7b94a/f197be75380aaa333c949bb8a1fe0510/aspnetcore-runtime-9.0.1-linux-arm64.tar.gz";
        hash = "sha512-433BRF5TwAvZUKUx+rgzVN77vgbG9zr0u+8gv87cBIOpj0eDaae8fX5S41srM61zeB4lW0aQDYMeJ3DNRF1pxQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/78308995-ac02-4bed-b5c3-eefb06ff907c/795e0c20df95d8c432fda2a189235b67/aspnetcore-runtime-9.0.1-linux-x64.tar.gz";
        hash = "sha512-5fwwk67VdW3q4+YfmLn0uwyEcxnbMMvRZowlEeBlKcL2peGRfsd2/is2ofe7fgCfySX+5X+HaWqNUCpsj13GEw==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2cfd68f3-5259-451d-83b1-6b5e80932813/bae5e023e887e42639426dd0824ac6bf/aspnetcore-runtime-9.0.1-linux-musl-arm.tar.gz";
        hash = "sha512-PqVcxQmNwIkJo4Uhn60eOGNfbu9s1m6lJrkt1X92XcNIOAQi5eC5yK3ihuGOcTyqS3/y0Gojw/7TG4tckdLcaw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f3b0e483-26b2-4115-8a8d-983c9b0ca58a/4d0058d82438c8de99347f40d3dee091/aspnetcore-runtime-9.0.1-linux-musl-arm64.tar.gz";
        hash = "sha512-6afiV/awnkjFIrclvoq0mOVxidZof4QKN6uf5BkumFvd2ZpmNBjF1dlu58fCufcOCPeGqkobIHVIWGvT/MNxDg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d55550d5-16dc-4b17-90c7-e8bf65657e09/b3d4c31dd4c933aaa50e920f5465b111/aspnetcore-runtime-9.0.1-linux-musl-x64.tar.gz";
        hash = "sha512-0/YJGElZhJ91JP37VcXPmoOR0KdzSDqmZZ2bqhUmVoNfJsL+m6Mi5xio63eB+5lutOvGlTvq9v37VijvMb/IUw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/26f85624-0eaf-4edc-a83f-428472ab31df/ba32371bac29f1738b9b0eb959dab0a3/aspnetcore-runtime-9.0.1-osx-arm64.tar.gz";
        hash = "sha512-uKs4mbELhxFZsBiJaUSEzD2bOueKFZY41oZJoiw/Myi5LENcW830moa8SIu70PynFD9vZk9llMVSQjw36tmZmA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6655b880-82dc-43d1-b5b2-f76d6a3c431c/4752d9d4811a2148de7eef5dcfd08441/aspnetcore-runtime-9.0.1-osx-x64.tar.gz";
        hash = "sha512-SusJQ4d9v5NfZVTGN9KqGPjvIulpLmzT1xbd4t1UEeSIF2fL6cVUvY7EPCCahqJhlMJhjGDRFboGOOkugEI8wA==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.1";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f8762afd-ce2a-461c-9280-0f6c377b92a7/9ca2330917e1ed7dadd5f1838b6ba44d/dotnet-runtime-9.0.1-linux-arm.tar.gz";
        hash = "sha512-sczLhtqZEvy4FkE3GOJk2Jnp78QqGf2KbMuCZbZc5P6Mh40LjVwGM7Hg5LL/PuUzE6ZuP5LDsVP73+METxvMlg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8a8a85c8-3364-42e4-a9fa-bc4d33e4a263/cb6b67c1ef5a8fd779dc43096c1f2a14/dotnet-runtime-9.0.1-linux-arm64.tar.gz";
        hash = "sha512-ODmbYTn3LvHYNuQYRVSUqAQov0HzqvI1F0n/FEMRdmSHUz1aPJvTWcGJuTc/JDd66IaCf0UnLEAZ4itZR3O4ew==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4ec0d4e4-9774-4d69-b9a2-db99ccb24a1a/b108f97029f83c8a27d041e90583ba5c/dotnet-runtime-9.0.1-linux-x64.tar.gz";
        hash = "sha512-1KMZRKWrBjA33KUUHbyEZtDIlLjSVgJWeCvb5ajoZYXoxMeJxA++UdVrOFPhWtugmFvcaukchadjVlMW4cPPyw==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/391e3ee0-16aa-4294-8641-3438307e624d/d244e58fbeff1482b0f8d3aacc6cc621/dotnet-runtime-9.0.1-linux-musl-arm.tar.gz";
        hash = "sha512-rIp746sIlVOYE8H2fDOqk+5y4qx/LYjuPKIfFEeeEaQGTN6afhWilEIiuNfChY3dOd6fbC0ni0Ep9eO6i5w44w==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/966184c6-ae9d-42d9-a5d6-1f14c46ffafd/fc65efc3447d3f1dced1c156742be6fa/dotnet-runtime-9.0.1-linux-musl-arm64.tar.gz";
        hash = "sha512-z2hldU48KLY79Oc9uVogeQKLkTL/xr7kqnrwPuFcdWChPQcmCWWDO0OYXYteL1Cndv8Xv1NDYFscG8I53a88XA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/dec9d9de-effe-48df-83b1-0c83f54e4cbc/cfe914fe2e2e9edb6138ce9328051f10/dotnet-runtime-9.0.1-linux-musl-x64.tar.gz";
        hash = "sha512-ObxzvnEq/KtBQlwuQqpQmBM8+aIID5HUxl8nTCxrxvgSeToX+O1rOlvKveTMXuW+g9yb750/OxDXnQ0/ALS1Xw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5c1d13ac-90d1-4f76-bcb1-d404b1ef6748/137435417c82ec2a5a519555b93b2344/dotnet-runtime-9.0.1-osx-arm64.tar.gz";
        hash = "sha512-9l9lDuPCicoJL6FRo9nPNP6i9UJvCYgsGU/nFlXsrypoGy1Qi5x4SdbJCMpnliXcSBcdAFgM3/f5gfBRioQ8ZQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/36d3662e-b23c-46cb-994c-3a46bf2b9759/2c090a2be99f96cb33a56183e747e27b/dotnet-runtime-9.0.1-osx-x64.tar.gz";
        hash = "sha512-uZfCwPA1DvKbpuhlrAnr7LHTYy4qdWG1q+I70PtqvIwMpziNbPF8WcqH3YFoYE3taDmnsWzqGvvjbKVyNFFeGw==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.102";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8f7ff743-f739-4b7c-835b-9405b3f7604f/b903530c774c08f30d3de3029f2e0bf9/dotnet-sdk-9.0.102-linux-arm.tar.gz";
        hash = "sha512-LExp1Gw+V+2ZBRip2CljZl2DXGalfaVLnSHiLCog6AGAINyxkO71Tf5owAH8zjhTYesr0piWMRoWg1mf+eandw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/555b12ca-d25f-4d4a-8c62-03b57998981e/b8f8f88c7809ea6c0e1d127deb18d8c6/dotnet-sdk-9.0.102-linux-arm64.tar.gz";
        hash = "sha512-y3iTHcu5SKUEiR8RLxEhXyeS0WnwoLU+qoHAP8S6eNMakcYKQYCa5uLdyuhkAIWhWeSSA1zt/aaNJlu+tL+LLg==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0e717d01-aad7-475a-8b67-50c59cf043b1/6eaa1c636e15ec8e1b97b3438360c770/dotnet-sdk-9.0.102-linux-x64.tar.gz";
        hash = "sha512-8JNQfvY1w/jlcr97bqfhRLhcz2t8b5FNPxgveCIApgiHKGY99cmr4GOMm9Jz/eN2nsgkplFvX85zTEpGZM4wmQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/db81a835-d9dc-4094-9c5c-cda20e684556/2d80354042afe6c8a2ef2f54c48a86cf/dotnet-sdk-9.0.102-linux-musl-arm.tar.gz";
        hash = "sha512-42Pj1O3Kk4MNGLzr1B4BvyhWsJWucOGiSwUzq7ClB+TB8VQv8wRsKFaJMY2sfitccaFmvLWTOoq2jYAL8+7fAw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a35ae2c2-e906-4bb1-b12a-a9d435231626/d0da093a240d41c06da2f49dc3011a13/dotnet-sdk-9.0.102-linux-musl-arm64.tar.gz";
        hash = "sha512-XamORsKA4hw3NKDJCB5923itYndaUaEptCpvAhMw0mOoddovRKeq/oFW58muD5uyG1AgV2krNg8q/giC8OYRMg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5e11d2af-f335-44f6-90a0-a99cdf806855/97268da6caffc1e8182525c7a2f01b74/dotnet-sdk-9.0.102-linux-musl-x64.tar.gz";
        hash = "sha512-YOCRhU0X2ppgEVafCkgZ6scs5v4G0BdX/uuDrVbBdkX6Q4JXYx7Lv27pSsOpc+/5rU0+Et6t2j60HBtpyo1TCA==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/1b4a1593-695b-4496-aa2a-55fa572bd71a/3b44622f52d4695513dff04f0bbcc404/dotnet-sdk-9.0.102-osx-arm64.tar.gz";
        hash = "sha512-E2MsnljY+kbxkSVtGA7RkIngiyQogYJd02gvCC1lvMbZdWYp/v2rYJwRJltgQ9wRY1Jj/odhM5ty02YIrLQ1dA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/373e3b64-d88b-4d83-adf3-eb48a6d6e76c/0d24e9cdbb0e75999fc0c17dafb1ea17/dotnet-sdk-9.0.102-osx-x64.tar.gz";
        hash = "sha512-Aj6RC2SBmZGDGqDlMEQ/qYX6Zzkg/ykVQa17ekpTLiD1rIn5qRsulWz2mzgh7xNpgoz0bFROGDqFQlrktyXhhw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk = sdk_9_0;

  sdk_9_0 = sdk_9_0_1xx;
}
